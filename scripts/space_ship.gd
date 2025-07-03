extends Node3D

var selected := false
# zmienne do highlightów i materiałów
@export var mesh: MeshInstance3D
@export var highlightMaterial: Material
@export var selectionMaterial: Material

@export var speed: int = 5  # maksymalna liczba kroków na turę (zastępuje distanceMovedThisTurn do kontroli ruchów)
@export var animationVelocity: float = 5.0

var distanceMovedThisTurn: int = 0
var mapManager
var ships = []
var travelpoints = []
var owned_planets: Array = []
var gold: int = 0
var technology: int = 0

func _ready() -> void:
	mapManager = get_parent()
	distanceMovedThisTurn = 0
	travelpoints = []

func addShip(ship):
	ships.append(ship.ships)

func merge(shipGroup):
	ships.append(shipGroup.ships)
	shipGroup.queue_free()

func split(shipsToSplit):
	for i in shipsToSplit:
		ships.erase(i)
	var newShip = preload("res://addons/naejimer_3d_planet_generator/scenes/planet_gaseous.tscn").instantiate()
	add_sibling(newShip)
	newShip.addShip(shipsToSplit)
	newShip.highlightStars(true)

func battle():
	pass  # do implementacji

func _on_static_body_3d_mouse_entered() -> void:
	if not selected:
		mesh.material_overlay = highlightMaterial

func _on_static_body_3d_mouse_exited() -> void:
	if not selected:
		mesh.material_overlay = null

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
		selected = !selected
		mesh.material_overlay = selectionMaterial if selected else highlightMaterial
		highlightStars(selected)

func highlightStars(highlight: bool):
	var playerPoint = mapManager.astar3.get_closest_point(global_position)
	for pointID in mapManager.astar3.get_point_ids():
		var path_length = mapManager.astar3.get_id_path(playerPoint, pointID).size()
		if highlight and path_length <= speed - distanceMovedThisTurn:
			mapManager.dictOfPoints[pointID].selected(true, self)
		else:
			mapManager.dictOfPoints[pointID].selected(false, self)

func move(pointLocation: Vector3):
	if distanceMovedThisTurn >= speed:
		print("Brak ruchów w tej turze")
		return

	var playerPoint = mapManager.astar3.get_closest_point(global_position)
	var endPoint = mapManager.astar3.get_closest_point(pointLocation)
	travelpoints = mapManager.astar3.get_id_path(playerPoint, endPoint)

func endTurn():
	distanceMovedThisTurn = 0
	travelpoints.clear()

func _process(delta: float) -> void:
	if travelpoints.size() > 1:
		var next_point_position = mapManager.astar3.get_point_position(travelpoints[1])

		if global_position.distance_to(next_point_position) < 0.1:
			global_position = next_point_position
			distanceMovedThisTurn += 1

			var point_id = travelpoints[1]
			if mapManager.dictOfPoints.has(point_id):
				var planet = mapManager.dictOfPoints[point_id]
				capture_planet(planet)


			highlightStars(true)
			travelpoints = travelpoints.slice(1, travelpoints.size())
		else:
			get_node("RocketMesh").look_at(next_point_position + Vector3(0, 0.5, 0))
			var movementVector = global_position.direction_to(next_point_position) * animationVelocity
			global_position += movementVector * delta

func calculate_income():
	var total_gold := 0
	var total_technology := 0
	for planet in owned_planets:
		if planet.has_method("gold_income"):
			total_gold += planet.gold_income()
		if planet.has_method("science_income"):
			total_technology += planet.science_income()
	gold += total_gold
	technology += total_technology

func capture_planet(planet):
	if planet.has_method("set_planet_owner"):
		planet.set_planet_owner(GameSettings.player_name)
	if not owned_planets.has(planet):
		owned_planets.append(planet)
	# Opcjonalnie: tutaj możesz wywołać aktualizację UI itp.

extends Node3D
var selected:= false
#these variables determine what gets highlighted and the material used
@export var mesh:MeshInstance3D
@export var highlightMaterial:Material
@export var selectionMaterial:Material
# these variables determine the distance the ship can travel per turn (speed) and the velocity of the animation
@export var speed: int
@export var animationVelocity:float
# these variables simply hold important numbers
var distanceMovedThisTurn
var mapManager
var movementVector=Vector3(0,0,0)
var travelpoints=[0]
#when the spaceship object is created it MUST be a child of the map generator as it uses a lot of it's data
func _ready() -> void:
	mapManager=get_parent()
	distanceMovedThisTurn=0
#function tied to mouse signals runs when the mouse enters the static body colision shape
func _on_static_body_3d_mouse_entered()->void:
	if not selected:
		mesh.material_overlay=highlightMaterial
#function tied to mouse runs when it exits the static body colision shape
func _on_static_body_3d_mouse_exited()->void:
	if not selected:
		mesh.material_overlay= null
#function tied to mouse runs when the static body colision shape recieves a mouse input (in this case click)
func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3,shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
			selected = not selected
			if selected:
				mesh.material_overlay=selectionMaterial
			else:
				mesh.material_overlay=highlightMaterial
			highlightStars(selected)
#highlights the stars the ship can reach or removes the highlight if the boolean is false
func highlightStars(highlight):
	if highlight:
		var playerPoint=mapManager.astar3.get_closest_point(self.position)
		for pointID in mapManager.astar3.get_point_ids():
			if mapManager.astar3.get_id_path(playerPoint,pointID).size()<=speed-distanceMovedThisTurn:
				mapManager.dictOfPoints[pointID].selected(true,self)
			else:
				mapManager.dictOfPoints[pointID].selected(false,self)
	else:
		for pointID in mapManager.astar3.get_point_ids():
			mapManager.dictOfPoints[pointID].selected(false,self)
#populates the array of points the ship moves along when a highlighted star is clicked
func move(pointLocation):
	var playerPoint=mapManager.astar3.get_closest_point(self.position)
	var endPoint=mapManager.astar3.get_closest_point(pointLocation)
	travelpoints=mapManager.astar3.get_id_path(playerPoint,endPoint)
#resets movement range should be called when end of turn is eventually implemented
func endTurn():
	distanceMovedThisTurn=0
#runs every frame most of the time simply passes by if statement and does nothing it's an easy check so performance shouldn't really be impacted
func _process(delta: float) -> void:
	#if there is a point to travel to (as the zero index is always either the current position or the one you just moved from)
	if travelpoints.size()>1:
		#look at the point and set a velocity vector moving towords it
		get_node("RocketMesh").look_at(mapManager.astar3.get_point_position(travelpoints[1])+Vector3(0,0.5,0))
		var movementVector= global_position.direction_to(mapManager.astar3.get_point_position(travelpoints[1]))*animationVelocity
		#if very close to goal
		if self.position.distance_to(mapManager.astar3.get_point_position(travelpoints[1]))<0.1:
			#moves to the next goal clears zero index of array and counts up distance traveled
			position=mapManager.astar3.get_point_position(travelpoints[1])
			distanceMovedThisTurn+=1
			highlightStars(true)
			travelpoints=travelpoints.slice(1,travelpoints.size())
		#move based on velocity vector
		position=position+movementVector*delta

extends Node3D
#mesh to be outlined and outline shader
@export var mesh:MeshInstance3D
@export var selectionMaterial:Material
@export var planet_id: String = "Planet_X"
@onready var label = $Label3D  # dostosuj ścieżkę, jeśli Label3D jest głębiej
#stores the spaceship that is highlighting the star
var selectedBy=null
#placeholder for bulding slots
var building_slots : Array = []
var rng = RandomNumberGenerator.new()
var gold=0
var science=0
var planets=[]

func apply_name():
	label.text = planet_id
func _process(delta: float) -> void:
	var i=1
	for planet in planets:
		i+=1
		planet.rotate_y(delta/2)
		var revolutionVector=planet.global_position-self.global_position
		revolutionVector=revolutionVector.rotated(Vector3(0,1,0),delta*i/10)
		planet.global_position=self.global_position+revolutionVector
func _ready() -> void:
	randomize()
	var RandomStar=rng.randi_range(0,4)
	var material: ShaderMaterial=$MeshInstance3D.get_surface_override_material(0)
	match RandomStar:
		0: 
			#red Dwarf
			material.set_shader_parameter("Sun_Color",Vector4(0.35,0.03,0.029,1.0))
			material.set_shader_parameter("Core_Color",Vector3(0.4,0.0,0.007))
			var rngScale=rng.randf_range(0.5,0.8)
			mesh.mesh.radius=0.5*rngScale
			mesh.mesh.height=1*rngScale
			generatePlanets(1,3,1.5)
		1: 
			#yellow dwarf
			material.set_shader_parameter("Sun_Color",Vector4(0.4,0.157,0,1.0))
			material.set_shader_parameter("Core_Color",Vector3(0.4,0.0,0.007))
			var rngScale=rng.randf_range(0.5,0.8)
			mesh.mesh.radius=0.5*rngScale
			mesh.mesh.height=1*rngScale
			generatePlanets(1,3,1.5)
		2: 
			#White dwarf
			material.set_shader_parameter("Sun_Color",Vector4(0.4,0.3,0.1,1.0))
			material.set_shader_parameter("Core_Color",Vector3(0.4,0.2,0.1))
			var rngScale=rng.randf_range(0.4,0.6)
			mesh.mesh.radius=0.5*rngScale
			mesh.mesh.height=1*rngScale
			generatePlanets(1,3,1.5)
		3: 
			#Red Giant
			material.set_shader_parameter("Sun_Color",Vector4(0.4,0.02,0.029,1.0))
			material.set_shader_parameter("Core_Color",Vector3(0.5,0.0,0.007))
			var rngScale=rng.randf_range(1,1.3)
			mesh.mesh.radius=0.5*rngScale
			mesh.mesh.height=1*rngScale
			generatePlanets(1,2,2.5)
		4: 
			#Blue Giant
			material.set_shader_parameter("Sun_Color",Vector4(0.076,0.3,0.5,1.0))
			material.set_shader_parameter("Core_Color",Vector3(0.078,0.3,0.3))
			var rngScale=rng.randf_range(1,1.3)
			mesh.mesh.radius=0.5*rngScale
			mesh.mesh.height=1*rngScale
			generatePlanets(1,2,2.5)
func generatePlanets(lowerLimit,upperLimit,distance):
	var number=rng.randi_range(lowerLimit,upperLimit)
	for i in range(number):
			var RandomPlanet=rng.randi_range(0,4)
			match RandomPlanet:
				0:
					#gas giant
					var planet= preload("res://addons/naejimer_3d_planet_generator/scenes/planet_gaseous.tscn").instantiate()
					add_child(planet)
					planets.append(planet)
					science+=5
				1:
					#ice planet
					var planet= preload("res://addons/naejimer_3d_planet_generator/scenes/planet_ice.tscn").instantiate()
					add_child(planet)
					planets.append(planet)
					science+=4
					gold+=1
				2: 
					#lava planet
					var planet= preload("res://addons/naejimer_3d_planet_generator/scenes/planet_lava.tscn").instantiate()
					add_child(planet)
					planets.append(planet)
					gold+=3
					science+=1
				3:
					#earth like planet
					var planet= preload("res://addons/naejimer_3d_planet_generator/scenes/planet_terrestrial.tscn").instantiate()
					add_child(planet)
					planets.append(planet)
					gold+=5
					science+=5
				4:
					#sand planet
					var planet= preload("res://addons/naejimer_3d_planet_generator/scenes/planet_sand.tscn").instantiate()
					add_child(planet)
					planets.append(planet)
					gold+=6
			var randVector=Vector3(rng.randf_range(-1,1),0,rng.randf_range(-1,1))
			randVector=randVector.normalized()
			planets[i].global_position=self.global_position+(randVector*(i+distance)/2)
func select():
	mesh.material_overlay = selectionMaterial

func unselect():
	mesh.material_overlay = null


#function called by a ship when highliting stars
func selected(selected,ship):
	if selected:
		selectedBy=ship
		mesh.material_overlay= selectionMaterial
	else:
		mesh.material_overlay= null
		selectedBy=null
#when clicked and highlighted calls move function of the ship highlighting it
func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
		
		if selectedBy != null:
			selectedBy.move(self.position)
		
		if selectedBy == null:
			# zaznacz przez gracza (GUI)
			var game3d = get_node("/root/Game3D")
			if game3d and game3d.has_method("select_star"):
				game3d.select_star(self)
			
			# GUI aktualizacja
			var gui_node = get_node("/root/InGameGui/UI")
			if gui_node and gui_node.has_method("update_tab_name"):
				gui_node.update_tab_name(planet_id)
			if gui_node and gui_node.has_method("update_building_slots"):
				gui_node.update_building_slots(self)
			if gui_node and gui_node.has_method("update_income_labels"):
				gui_node.update_income_labels(self)

				
				

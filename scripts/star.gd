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




func apply_name():
	label.text = planet_id



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

				
				

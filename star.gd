extends Node3D
#mesh to be outlined and outline shader
@export var mesh:MeshInstance3D
@export var selectionMaterial:Material
#stores the spaceship that is highlighting the star
var selectedBy=null
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
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
			if selectedBy!=null:
				selectedBy.move(self.position)

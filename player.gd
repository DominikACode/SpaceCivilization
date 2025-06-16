extends RigidBody3D
var speed=5
var goal
var direction=Vector3(0,0,0)
func _ready():
	set_meta("name", "Commander X")  # You can customize this
	
func move(g:Vector3):
	goal=g
	direction= global_position.direction_to(goal)
	get_node("RocketMesh").look_at(goal+Vector3(0,1,0))
func _process(delta: float) -> void:
	linear_velocity=speed*direction
	if goal!=null:
		if global_position.distance_to(goal)<0.1:
			global_position=goal
			linear_velocity=Vector3(0,0,0)
			direction=Vector3(0,0,0)
			

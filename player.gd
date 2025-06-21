extends RigidBody3D
#camera movement variables exported for easy tinkering
@export var moveSpeed = 2.0
@export var rotationSpeed = 1.5
@export var hightThresholdUp=8
@export var hightThresholdDown=-5
#initial velocities of zero
var velocity = Vector3.ZERO
var angularVelocity = 0.0
func _ready():
	set_meta("name", "Commander X")  # You can customize this
	
func _process(delta: float) -> void:
	var velocity = Vector3.ZERO
	var angularVelocity = 0.0
	#Creates a velocity vector based on player input as well as a rotation direction
	if Input.is_action_pressed("move_forward"):
		velocity.z += -1;
	if Input.is_action_pressed("move_back"):
		velocity.z += 1;
	if Input.is_action_pressed("move_left"):
		velocity.x += -1;
	if Input.is_action_pressed("move_right"):
		velocity.x += 1;
	if Input.is_action_pressed("zoom_in") and self.position.y>hightThresholdDown:
		velocity.y += -1;
	if Input.is_action_pressed("zoom_out") and self.position.y<hightThresholdUp:
		velocity.y += 1;
	if Input.is_action_pressed("turn_left"):
		angularVelocity+=1
	if Input.is_action_pressed("turn_right"):
		angularVelocity+=-1
	#rotates the camera
	rotate_y(angularVelocity*delta*rotationSpeed)
	#normalizes the vector so that diagonal directions move at the same speed
	velocity=velocity.normalized()*moveSpeed
	#moves the camera and moves it at double speed if pressing shift
	if Input.is_action_pressed("speed_up"):
		translate(velocity*delta*moveSpeed*2)
	else:
		translate(velocity*delta*moveSpeed)

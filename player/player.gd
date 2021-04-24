extends KinematicBody


const MOVEMENT_SPEED = 8.22 # a baseball player's average

const JUMP_POWER = 6.0

const MOUSE_SENSITIVITY = 0.02

const GRAVITY = -9.8

var velocity = Vector3.ZERO

onready var camera_holder = $Holder

onready var camera = camera_holder.get_node("Camera")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event):
	if not event is InputEventMouseMotion:
		return
	
	var direction = -event.relative * MOUSE_SENSITIVITY
	
	camera_holder.rotate_y(direction.x)
	camera.rotation.x = clamp(camera.rotation.x + direction.y, -PI / 2.0, PI / 2.0)


func _physics_process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit(0)
	
	var horizontal = Vector2.ZERO
	
	horizontal.x += Input.get_action_strength("move_right")
	horizontal.x -= Input.get_action_strength("move_left")
	
	horizontal.y += Input.get_action_strength("move_backward")
	horizontal.y -= Input.get_action_strength("move_forward")
	
	horizontal = horizontal.normalized() * MOVEMENT_SPEED
	horizontal = horizontal.rotated(-camera_holder.rotation.y)
	
	velocity.x = horizontal.x
	velocity.z = horizontal.y
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_POWER
	
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)

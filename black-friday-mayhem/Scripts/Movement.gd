extends MeshInstance3D

extends CharacterBody3D

@export var acceleration : float = 500.0
@export var maxSpeed : float = 600.0
@export var forwardRotationSpeed : float = 6.0
@export var turningRotationSpeed : float = 7.0
@export var breakingSpeed : float = 120.0
@export var maxRotationSpeed : float = 4.0
@export var traction : float = 0.5
@export var useArrow : bool
@export var debug : bool
@export var inventory : Inventory
var speed : float
var isMovingForward = false
var isMovingBackward = false

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("Right", "Left", "Forward", "Backward")
	var direction_ground = Vector3(input_dir.x, 0, input_dir.y)
	if isMovingForward:
		rotation.y += direction_ground.x * delta * 4
	if isMovingBackward:
		rotation.y += -direction_ground.x * delta * 4
	var forward = direction_ground.rotated(Vector3.UP, rotation.y)
	if isMovingForward or isMovingBackward:
		position += forward * delta * 4
	#position = $"Example Player/Camera3D".global_basis * direction_ground * speed *  4 * delta
	#velocity.y = velocity_y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Forward"):
		isMovingForward = true
		pass
	if event.is_action_released("Forward"):
		isMovingForward = false
	if event.is_action_pressed("Backward"):
		isMovingBackward = true
	if event.is_action_released("Backward"):
		isMovingBackward = false
	pass

func collect(item: InvItem):
	inventory.insert(item)


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
var isTurning = false
var forward = Vector3.ZERO

func _ready() -> void:
	if !useArrow:
		$Shape2.visible = false
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Gets vector 2, for left, right, up, and down (1 or 0)
	var input_dir = Input.get_vector("Left", "Right", "Backward", "Forward")
	
	# Vector 3 for change 3D space (left right on x, up down on z)
	var direction_ground = Vector3(-input_dir.x, 0, -input_dir.y)
	
	# Forward vector for player
	forward = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
	
	if velocity.length() > 0.0000001: # Code for slowing down
		# print(velocity.length())
		velocity -= velocity.lerp(Vector3.ZERO, traction) * delta
		speed -= acceleration * delta * traction
		speed = clamp(speed, 0, maxSpeed)
		# velocity = forward * delta * speed
	
	if isMovingForward: # Fixes rotations based on if going forward
		speed += acceleration * delta
		speed = clamp(speed, -maxSpeed, maxSpeed)
		#rotationSpeed += rotationAcceleration * delta
		#rotationSpeed = clamp(rotationSpeed, -maxRotationSpeed, maxRotationSpeed)
		rotation.y += direction_ground.x * delta * forwardRotationSpeed
		velocity = forward * delta * speed
	if isMovingBackward: # Fixes rotations based on if going backward
		speed -= delta * breakingSpeed
		speed = clamp(speed, -maxSpeed, maxSpeed)
		#rotationSpeed += rotationAcceleration * delta
		#rotationSpeed = clamp(rotationSpeed, -maxRotationSpeed, maxRotationSpeed)
		rotation.y += direction_ground.x * delta * forwardRotationSpeed
		velocity = forward * delta * speed
		
	if isTurning and input_dir.y == 0: # If is turning, and is not on the gas (essentially)
		var originalVector = velocity / delta # undo modifications
		if speed > 0.5:
			originalVector = originalVector / speed
		originalVector = originalVector.rotated(Vector3.UP, -rotation.y) # rotate it back to what it was 
		
		# Gex -> get x (ex) -> gex (also, gex, the best video game of all time: )
		var gex = Vector3(direction_ground.x * 0.70710676908493 - (0.70710676908493 * originalVector.x), 0, originalVector.z) # include the new forward from the velocity to maintain it's direction (and magnitude, oh yeah!)
		rotation.y += gex.x * delta * turningRotationSpeed # Change rotation based on new input from player (left, right)
		var newVel = gex.rotated(Vector3.UP, rotation.y) # make vector3 based on new vector (input.x, 0, velocity.z)
		newVel = newVel * delta * speed
		velocity = newVel # Set velocity to new vector * delta * speed
		
		# print("SUPER IMPORTANT FOR: ", velocity.length())
		# print("NEW VEL: ", newVel, " VEL: ", velocity)
		pass
	#elif velocity.length() < maxRotationSpeed and rotationFix:
		#var newVel = Vector3(0,0,-1)
		#newVel = newVel.rotated(Vector3.UP, rotation.y)
		#velocity = newVel * delta
		#rotationFix = false
		#pass
	
	# print("Vel: ", velocity.length())
	# print("Left: ", input_dir.x, " ws: ", input_dir.y)	
		#var f = Vector3(0,100,0)
		#$RigidBody3D.apply_central_force(f)#forward*delta*speed)
	move_and_slide()
	pass

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
	if event.is_action_pressed("Left") or event.is_action_pressed("Right"):
		isTurning = true
		pass
	if event.is_action_released("Left") or event.is_action_released("Right"):
		isTurning = false
		#rotationFix = true
	pass

func collect(item: InvItem):
	inventory.insert(item)

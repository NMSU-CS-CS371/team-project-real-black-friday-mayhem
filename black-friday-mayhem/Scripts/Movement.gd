
extends CharacterBody3D

signal stop_velocity

@onready var sprite = $AnimatedSprite3D
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
var controlAllowed = true
var isMoving = false
var rotationChange = 0


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
	
	# velocity.length() is the magnitude of the velocity, or essentially how much velocity it has in every direction.
	#(how much velocity)
	if velocity.length() > 0.05: # Code for slowing down
		# this code makes the velocity go to 0 over time, based on traction
		velocity -= velocity.lerp(Vector3.ZERO, traction) * delta
		
		# this subtracts to the speed so that it is gradual when the player stops fully.
		speed -= acceleration * delta * traction
		
		# This makes sure it's never less than 0 or more than the max speed
		speed = clamp(speed, 0, maxSpeed)

		# This is a boolean keeping track if the player is moving
		isMoving = true
	else:
		#If the player is not slowing down (in physics, it must always be slowing down, we have counter forces, which is why we move in the first place
		# But if the player is no longer slowing down, the player is no longer moving
		isMoving = false
		
		#makes sure the velocity is zero
		velocity = Vector3.ZERO
	
	# This is a boolean if the player is moving forwards, and how the turns should work.
	if isMovingForward: # Fixes rotations based on if going forward
		#add to speed
		speed += acceleration * delta
		#Make sure it is never more than it should
		speed = clamp(speed, -maxSpeed, maxSpeed)
		
		# This keeps track of how much we want to change the player's rotation, and how much it has changed since starting the game.
		# direction ground is a vector of the player's movement (1, 0, or negative on on a,d, left_arrow, right_arrow)
		# Forward rotation speed is how fast the player should be rotation while the player is also holding down W, or up_arrow
		rotationChange = direction_ground.x * delta * forwardRotationSpeed
		
		#change the rotation of the player based on rotation change
		rotation.y += rotationChange
		
		#The velocity of the player is the player's forward direction * the player's framerate * how fast the player is going.
		#rotation.y changes the player's forward by the way. (probably obvious...)
		velocity = forward * delta * speed
	if isMovingBackward and isMoving: # Fixes rotations based on if going backward
		#essentially the same as isMovingForward, copy paste comments here..
		
		#subtract to speed based on the breaking speed
		speed -= delta * breakingSpeed
		
		#Make sure it is never more or less than it should be
		speed = clamp(speed, -maxSpeed, maxSpeed)
		
		# This keeps track of how much we want to change the player's rotation, and how much it has changed since starting the game.
		# direction ground is a vector of the player's movement (1, 0, or negative on on a,d, left_arrow, right_arrow)
		# Forward rotation speed is how fast the player should be rotation while the player is also holding down W, or up_arrow
		rotationChange = direction_ground.x * delta * forwardRotationSpeed
		
		#change the rotation of the player based on rotation change
		rotation.y += rotationChange
		
		#The velocity of the player is the player's forward direction * the player's framerate * how fast the player is going.
		#rotation.y changes the player's forward by the way. (probably obvious...)
		velocity = forward * delta * speed
	
	#If the player is turning and is not going forward or backward
	if isTurning and input_dir.y == 0: # If is turning, and is not on the gas (essentially)
		#The goal is to essentailly undo all the code for when you're moving, add more turning, and then redo the code.
		
		#The original vector is just the forward vector before adding speed or the delta
		var originalVector = velocity / delta # undo modifications
		if speed > 0.5:
			originalVector = originalVector / speed
		
		#rotate back to a normal vector (in sense of rotations, euler angles, quaternions and angle lock.
		#essentially, get a clean vector.
		originalVector = originalVector.rotated(Vector3.UP, -rotation.y) # rotate it back to what it was 
		
		# Gex -> get x (ex) -> gex (also, gex, the best video game of all time: )
		var gex = Vector3(direction_ground.x * 0.70710676908493 - (0.70710676908493 * originalVector.x), 0, originalVector.z) # include the new forward from the velocity to maintain it's direction (and magnitude, oh yeah!)
		#Here's the thought process here:
		#When the player is moving, (holding w), you have a direction_ground = (0, 1)
		#But when you are turning, you have something like (+-0.707106.., 0.707106..)
		#But since the player is no longer using w or up_arrow, it looks more like (+-1, 0)
		#Which breaks the code, so I'm essentially multiplying that +-1 with 0.707106..
		#This part: (0.70710676908493 * originalVector.x)
		#Is to account for the velocity the player already has, because what would happen is you would be able to turn indefinitely, (like adding gas) instead of just changing the forward direction of the player.
		
		#Sets the new rotational change based on gex and the special turningRotationSpeed for this specific scenario.
		rotationChange = gex.x * delta * turningRotationSpeed
		
		#Adds to the rotation.y of the player.
		rotation.y += rotationChange # Change rotation based on new input from player (left, right)
		
		#At this point, gex is based on the velocity's forward instead of the player's forward
		#This is why this code is so different in the first place. 
		#Because we are changing the velocity's direction, instead of adding to it. 
		var newVel = gex.rotated(Vector3.UP, rotation.y) # make vector3 based on new vector (input.x, 0, velocity.z)
		newVel = newVel * delta * speed
		velocity = newVel # Set velocity to new vector * delta * speed
	
	#This actually set's the velocity stuff to the player
	#(essentially asks for an update)
	move_and_slide()

func _input(event: InputEvent) -> void:
	#This checks if the player should be allowed to move
	if !controlAllowed:
		#If not, return.
		return
	
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
	if event.is_action_released("Left") or event.is_action_released("Right"):
		isTurning = false
	pass

func collect(item: InvItem):
	inventory.insert(item)

func _on_stop_velocity() -> void:
	velocity = Vector3.ZERO
	controlAllowed = false
	speed = 0
	isTurning = false
	isMovingForward = false
	isMovingBackward = false
	pass # Replace with function body.

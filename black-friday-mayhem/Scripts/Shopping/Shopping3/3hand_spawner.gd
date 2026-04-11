extends Node2D #Hand Spawn 3
#Hand Spawner is what spawns the hands infinitly 
#on initilization
#it gets the game from the minigame node
#if the spawn timer is not found it will not spawn any hands
#it will assign the timers wait time to be the hands spawn iterval 
#starts the spawner timer
#whenever the spawner timer runs out it will spawn a hand and then restart the timer

@export var hand_scene: PackedScene #hand nodes
@export var spawn_interval := 1.0
@export var max_hands := 20
@export var upLeft : Node2D
@export var lowerRight : Node2D
var game: Node

#ready func is to set up the scene
func _ready() -> void:
	game = get_parent()#game = to the parent node
	print("Spawner ready")#debug print
	#if cant find the SpawnTimer give error
	if not $SpawnTimer:
		push_error("SpawnTimer node missing!")
		return
	#Set Timer to the spawn interval
	$SpawnTimer.wait_time = spawn_interval
	#start the spawn timer
	$SpawnTimer.start()

#spawn timer timeout function
func _on_spawn_timer_timeout() -> void:
	#if game not found or game does not have an is_running method or the game is not running #return
	if not game or not game.has_method("is_running") or not game.is_running():
		return
	#if the child count is greater then the max spawned var
	if get_child_count() >= max_hands:
		return
	#call spawn hand
	spawn_hand()

#spawn hand funtion to spawn hand objects
func spawn_hand():
	#hand = a HandEnemy
	var hand = hand_scene.instantiate()
	#side = a random number between 1 and 4
	var side := randi() % 3
	#spawn side = random side chosen
	hand.spawn_side = side
	# get the hand position from what side the hand is on
	hand.position = get_spawn_position_from_side(side)
	#add the hand as a new child
	add_child(hand)
	# Rotate AFTER positioning
	var center := get_viewport_rect().size / 2
	#hand rotates to the center
	hand.look_at(center)
	#this links the hand to the Idem it needs to steal
	hand.target_item = game.choose_random_item()
	
#get spawn position from what side it is on
func get_spawn_position_from_side(side: int) -> Vector2:
	#get the screen size
	#var screen_size = get_viewport_rect().size
	#set the margin between the edges and the hands
	var margin := 30
	#match side (cases)
	var output : Vector2
	#if upLeft == null or lowerRight == null:
		#return Vector2.ZERO
	##var screenX = upLeft.position.x
	#var screenY = lowerRight.position.y
	match side:
		0: # TOP
			output = Vector2(randf_range(upLeft.global_position.x, lowerRight.global_position.x), upLeft.global_position.y)
		1: # BOTTOM
			output = Vector2(randf_range(upLeft.global_position.x, lowerRight.global_position.x), lowerRight.global_position.y)
		2: # LEFT
			output = Vector2(upLeft.global_position.x, randf_range(upLeft.global_position.y, lowerRight.global_position.y))
	#return the screen size divided by 2
	return output

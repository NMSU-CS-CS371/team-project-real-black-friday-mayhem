extends Node2D #Hand Spawn
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
	var screen_size = get_viewport_rect().size
	#set the margin between the edges and the hands
	var margin := 30
	#match side (cases)
	match side:
		0: # TOP
			return Vector2(randf_range(margin, screen_size.x - margin), margin)
		1: # BOTTOM
			return Vector2(randf_range(margin, screen_size.x - margin), screen_size.y - margin)
		2: # LEFT
			return Vector2(margin, randf_range(margin, screen_size.y - margin))
	#return the screen size divided by 2
	return screen_size / 2

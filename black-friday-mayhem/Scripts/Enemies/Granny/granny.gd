extends BaseCharacter #Grandma

#movement varibles
var time = 0.0
var radius = 5.0
var speed = 0.4
var angle = 0.0
var center : Vector3
#game variables
@export var game : Node3D
@onready var player = get_tree().get_first_node_in_group("Player")
var is_defeated = false
var playing_game = false
var punchies = preload("res://Scenes/Enemies/Grandma/punchies.tscn")
var hit = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center = global_position  # starting point = center of circle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_defeated :
		velocity = Vector3.ZERO
	elif playing_game :
		sprite.play("Final")
		velocity = Vector3.ZERO
	else :
		#-move-
		time += delta * speed
		#calculate new position
		var new_x = center.x + cos(time) * radius
		var new_z = center.z + sin(time) * radius
		var target_pos = Vector3(new_x, global_position.y, new_z)
		var direction = (target_pos - global_position)
		direction.y = 0
		velocity = direction / delta
	# velocity + apply_movement_and_animation() handles grounding now
	# no more per-frame raycasting :)
	apply_movement_and_animation(delta)

# Override update_animation since Granny uses specific hit-based animations
func play_if_not_flip(anim, flip):
	if sprite.animation != anim:
		sprite.flip_h = flip
		sprite.play(anim)

#update the animation
func update_animation() -> void:
	var direction = velocity	# global_position - last_position = velocity
	direction.y = 0				# ignore vertical movement for animation purposes
	#prevents tiny jittering movements
	if direction.length() < 0.001 :
		return
	#normalize the direction
	direction = direction.normalized()
	#decide animation
	if abs(direction.x) > abs(direction.z) :
		if direction.x > 0 :
			if hit == 0 :
				play_if_not_flip("Side1", true)
			elif hit == 1 :
				play_if_not_flip("Side2", true)
			elif hit >= 2 :
				play_if_not_flip("Side3", true)
		else :
			if hit == 0 :
				play_if_not_flip("Side1", false)
			elif hit == 1 :
				play_if_not_flip("Side2", false)
			elif hit >= 2 :
				play_if_not_flip("Side3", false)
	else :
		if direction.z > 0 :
			if hit == 0 :
				play_if_not_flip("Front1", false)
			elif hit == 1 :
				play_if_not_flip("Front2", false)
			elif hit >= 2 :
				play_if_not_flip("Front3", false)
		else :
			play_if_not_flip("Back", false)

func _on_hit_box_body_entered(body: Node3D) -> void:
	# Ensure the player exists and has stop_velocity signal
	if not body.is_in_group("Player"):
		return
	# Temporary fallback if player variable isn't fully set
	var game_active = false
	if player and "playing_game" in player:
		game_active = player.playing_game
	# Check if the player is currently playing the minigame before processing the hit
	if hit >= 2 && !game_active: #wait- who did this..? - Jaiden
		print("oh heck no")
		if player and "playing_game" in player:
			player.playing_game = true
		if body.has_signal("stop_velocity"):
			body.stop_velocity.emit()
		AudioManager.pause_main_music()
		var killer_instinct = punchies.instantiate()
		add_child(killer_instinct)
		killer_instinct.connect("game_finished", Callable(self, "_on_minigame_finished"))
	else:
		hit = hit + 1
		print("sorry.!")
		
# *jolena's code, thank you :, ) 
#function to recieve game results 
func _on_minigame_finished(result):
	if result == "win" :
		is_defeated = true
		print("granny defeated")
	playing_game = false
	AudioManager.resume_main_music()
	queue_free() # you killed grandma
	# how could you??? D, :

#this function is for the textbox when grandma is hit
func when_hit(_num) :
	pass
	#when the granny is hit I want to have you and the grandma stop
	#and a voice line of the grandma 
	#and you to be locked in
	#until you sound is over
	#wont increase granny hit until sound over

	#TO DO:
	#write comment that make sense pls ^

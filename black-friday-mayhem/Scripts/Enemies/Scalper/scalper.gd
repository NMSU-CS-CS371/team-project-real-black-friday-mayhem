extends BaseCharacter #Scalper

#movement varibles
var time = 0.0
var radius = 5.0
var speed = 1.0
var angle = 0.0
var center : Vector3
@export var enemy_type : Node3D #IDK what this is used for 
#minigame varibles
var Palcomon = preload("res://Scenes/Enemies/Scalper/palcomon.tscn") #minigame
var is_defeated = false
var playing_game = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center = global_position  # starting point = center of circle

func _physics_process(delta: float) -> void:
	#if enemy is defeated make sure has right sprite and is not moving
	if is_defeated:
		play_animation("defeated")
		#sprite.play("defeated")
		sprite.offset.y = -8
		$AnimatedSprite3D/Sprite3D.offset.y = -8
		velocity = Vector3.ZERO
	#else if you playing enemys mini game dont move
	elif playing_game:
		play_animation("forward")
		#sprite.play("forward")
		velocity = Vector3.ZERO
	#else enemy is moving
	else:
		time += delta * speed
		#calculate new position
		var new_x = center.x + cos(time) * radius
		var new_z = center.z + sin(time) * radius
		var target_pos = Vector3(new_x, global_position.y, new_z)
		# set velocity to move towards target pos to allow physics collision
		var direction = (target_pos - global_position)
		direction.y = 0
		velocity = direction / delta
	apply_movement_and_animation(delta)#used for animating the circle movement with sprite
	# moved movement and animation logic to entity_movement.gd

func _on_hit_box_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player"): # Check if collision is not player
		return
	if (is_defeated || playing_game) : 
		return
	playing_game = true
	for npc in get_tree().get_nodes_in_group("npc"):
		if npc.has_method("mute_voice_lines"):
			npc.mute_voice_lines()
	AudioManager.pause_main_music()
	
	#Tells the player to stop velocity
	if body.has_signal("stop_velocity"):
		body.stop_velocity.emit()
	#creates and starts minigame
	var battle = Palcomon.instantiate()
	add_child(battle)
	battle.connect("game_finished", Callable(self, "_on_minigame_finished"))
	
func play_animation(name : String):
	sprite.play(name)
	$AnimatedSprite3D/Sprite3D/SubViewport/AnimatedSprite2D.play(name)
	pass
#function to recieve game results 
func _on_minigame_finished(result):
	if result == "win" :
		is_defeated = true
		print("Enemy defeated")
	playing_game = false
	for npc in get_tree().get_nodes_in_group("npc"):
		if npc.has_method("unmute_voice_lines"):
			npc.unmute_voice_lines()
	AudioManager.resume_main_music()

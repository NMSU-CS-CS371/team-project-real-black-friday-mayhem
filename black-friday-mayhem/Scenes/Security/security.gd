extends Node3D

@export var dialogue_scene = preload("res://Scenes/Security/tutorial.tscn")
@onready var player = get_tree().get_first_node_in_group("Player")
var playing_game = false

#func _ready():
	#$Area3D.body_entered.connect(_on_body_entered)
	#$Area3D.area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	# Temporary fallback if player variable isn't fully set
	var game_active = false
	if player and "playing_game" in player:
		game_active = player.playing_game
	print("game active = "+str(game_active))
	
	# Check if the player is currently playing the minigame before processing the hit
	if !game_active:
		if player and "playing_game" in player:
			player.playing_game = true
		if body.has_signal("stop_velocity"):
			body.stop_velocity.emit()
			player.controlAllowed = false
			playing_game = true
			# Ensure the player exists and has stop_velocity signal
			for npc in get_tree().get_nodes_in_group("npc"):
				if npc.has_method("mute_voice_lines"):
					npc.mute_voice_lines()
		AudioManager.pause_main_music()
		var tutorial = dialogue_scene.instantiate()
		add_child(tutorial)
		tutorial.get_child(0).connect("dialogue_finished", Callable(self, "_on_tutorial_finished"))

func _on_tutorial_finished():
	playing_game = false
	player.controlAllowed = true
	player.playing_game = false
	for npc in get_tree().get_nodes_in_group("npc"):
		if npc.has_method("unmute_voice_lines"):
			npc.unmute_voice_lines()
	AudioManager.resume_main_music()

extends Node2D

var config = ConfigFile.new()
@onready var sceneTransition = $SceneTransition/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OptionsPanel.visible = false
	# attempt to load config file
	var err = config.load("res://config.ini")
	
	if err != OK:
		set_default_settings()
	
	apply_settings()
	# finish scene transition
	sceneTransition.get_parent().get_node("ColorRect").color.a = 255
	sceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout

func set_default_settings():
	config.set_value("options","music_volume",100.0)
	config.set_value("options","sfx_volume",100.0)
	config.set_value("options","fullscreen",0)
	config.save("res://config.ini")

func _on_play_pressed():
	# begin scene transition
	sceneTransition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_options_pressed():
	print("options pressed")
	# open options menu
	$OptionsPanel.load_settings(config)

func apply_settings():
	# apply settings from config file
	# the sound settings don't do anything right now
	# because we don't have sound :P
	# config.get_value("options","music_volume")
	# config.get_value("options", "sfx_volume")
	if config.get_value("options", "fullscreen") == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

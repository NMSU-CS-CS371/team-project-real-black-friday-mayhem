extends Node2D

var config = ConfigFile.new()
@onready var sceneTransition = $SceneTransition/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OptionsPanel.visible = false
	# attempt to load config file
	var err = config.load("res://config.ini")
	
	# if config file could not be loaded, set default settings
	if err != OK:
		set_default_settings()
	
	apply_settings()
	# finish scene transition
	sceneTransition.get_parent().get_node("ColorRect").color.a = 255
	sceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout

# set default settings if config file could not be loaded
func set_default_settings():
	config.set_value("options","master_volume",100.0)
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

# apply settings from config file
func apply_settings():
	
	# fetch volume settings
	var masterVolume = config.get_value("options","master_volume") / 100.0
	var musicVolume = config.get_value("options","music_volume") / 100.0
	var sfxVolume = config.get_value("options", "sfx_volume") / 100.0
	
	# set the audio bus volume
	AudioManager.set_master_volume(masterVolume)
	AudioManager.set_music_volume(musicVolume)
	AudioManager.set_sfx_volume(sfxVolume)
	
	# set window settings
	if config.get_value("options", "fullscreen") == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

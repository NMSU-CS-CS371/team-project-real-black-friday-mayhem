extends Node

class_name World
var config = ConfigFile.new()
@export var player : Node3D # THE CORRECT WAY OF FINDING THIS: get_tree().get_root().get_child(2).player
@onready var SceneTransition = $SceneTransition/AnimationPlayer

func _ready() -> void:
	$OptionsPanel.visible = false
	config.load("res://config.ini")
	
	SceneTransition.get_parent().get_node("ColorRect").color.a = 255
	SceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	SceneTransition.get_parent().get_node("ColorRect").visible = false

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("esc"):
		if $OptionsPanel.visible:
			$OptionsPanel._on_x_button_pressed()
		else:
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

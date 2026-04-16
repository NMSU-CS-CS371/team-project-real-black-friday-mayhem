extends Control

var music_volume: float
var sfx_volume: float
var fullscreen: int
var configGlobal: ConfigFile

signal settings_updated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ConfirmPanel.visible = false

func load_settings(config: ConfigFile):
	configGlobal = config
	# get settings from config file
	music_volume = config.get_value("options","music_volume")
	sfx_volume = config.get_value("options", "sfx_volume")
	fullscreen = config.get_value("options", "fullscreen")
	
	# apply settings to the UI
	$VolumeSliders/MusicVolume.value = music_volume
	$VolumeSliders/SFXVolume.value = sfx_volume
	$WindowButton.selected = fullscreen
	
	# show the panel
	visible = true

func _on_music_volume_changed(value: float):
	music_volume = value

func _on_sfx_volume_changed(value: float):
	sfx_volume = value

func _on_window_changed(value: int):
	fullscreen = value

func _on_x_button_pressed():
	# if any settings don't match saved settings
	if not check_settings():
		$ConfirmPanel.visible = true
	else:
		visible = false

# checks if settings in the options match settings in the config file
func check_settings() -> bool:
	var music_check = configGlobal.get_value("options","music_volume") == music_volume
	var sfx_check = configGlobal.get_value("options", "sfx_volume") == sfx_volume
	var fullscreen_check = configGlobal.get_value("options", "fullscreen") == fullscreen
	return music_check and sfx_check and fullscreen_check

func _on_save_pressed():
	# save all settings into config file
	configGlobal.set_value("options","music_volume",music_volume)
	configGlobal.set_value("options","sfx_volume",sfx_volume)
	configGlobal.set_value("options","fullscreen",fullscreen)
	configGlobal.save("res://config.ini")
	
	# apply the settings
	settings_updated.emit()
	
	# hide options panel
	visible = false

func _on_cancel_pressed():
	$ConfirmPanel.visible = false

func _on_discard_pressed():
	$ConfirmPanel.visible = false
	visible = false

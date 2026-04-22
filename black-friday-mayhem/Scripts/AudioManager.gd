extends Node

func pause_main_music() -> void:
	var main_music = get_tree().get_first_node_in_group("MainMusic")
	if main_music and main_music is AudioStreamPlayer:
		main_music.stream_paused = true

func resume_main_music() -> void:
	var main_music = get_tree().get_first_node_in_group("MainMusic")
	if main_music and main_music is AudioStreamPlayer:
		main_music.stream_paused = false

# control the master volume bus (implement main menu slider)
#func set_master_volume(value: float) -> void:
	# get the index of the master bus
	# convert the slider value (0.0 to 1.0) into dB - idk how
	# apply the new volume to the master bus
	
	# maybe if the value is 0, mute the bus

# control the specific music bus
#func set_music_volume(value: float) -> void:
	# get the index of the music bus
	# convert to decibels
	# apply it specifically to the music bus

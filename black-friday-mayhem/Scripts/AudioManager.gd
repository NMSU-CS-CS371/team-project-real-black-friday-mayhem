extends Node

func pause_main_music() -> void:
	var main_music = get_tree().get_nodes_in_group("MainMusic")
	for node in main_music:
		if node and node is AudioStreamPlayer:
			node.stream_paused = true

func resume_main_music() -> void:
	var main_music = get_tree().get_nodes_in_group("MainMusic")
	#var main_music = get_tree().get_first_node_in_group("MainMusic")
	for node in main_music:
		if node and node is AudioStreamPlayer:
			node.stream_paused = false

# control the master volume bus (implement main menu slider)
func set_master_volume(value: float) -> void:
	# get the index of the master bus
	var index = AudioServer.get_bus_index("Master")
	
	# convert to decibels
	value = linear_to_db(value)
	
	# apply it specifically to the master bus
	AudioServer.set_bus_volume_db(index, value)

# control the specific music bus
func set_music_volume(value: float) -> void:
	
	# get the index of the music bus
	var index = AudioServer.get_bus_index("Music")
	
	# convert to decibels
	value = linear_to_db(value)
	
	# apply it specifically to the music bus
	AudioServer.set_bus_volume_db(index, value)

# control the sfx bus
func set_sfx_volume(value: float) -> void:
	
	# get the index of the sfx bus
	var index = AudioServer.get_bus_index("SFX")
	
	# convert to decibels
	value = linear_to_db(value)
	
	# apply it specifically to the sfx bus
	AudioServer.set_bus_volume_db(index, value)

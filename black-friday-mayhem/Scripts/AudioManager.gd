extends Node

func pause_main_music() -> void:
	var main_music = get_tree().get_first_node_in_group("MainMusic")
	if main_music and main_music is AudioStreamPlayer:
		main_music.stream_paused = true

func resume_main_music() -> void:
	var main_music = get_tree().get_first_node_in_group("MainMusic")
	if main_music and main_music is AudioStreamPlayer:
		main_music.stream_paused = false

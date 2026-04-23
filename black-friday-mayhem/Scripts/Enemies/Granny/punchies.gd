extends Node2D

signal game_finished(result)

func emit_gamestate(win_state : String):
	emit_signal("game_finished", win_state)
	pass

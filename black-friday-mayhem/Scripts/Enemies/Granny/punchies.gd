extends Node2D
@onready var player = get_tree().get_first_node_in_group("Player")
signal game_finished(result)

func emit_gamestate(win_state : String):
	var item : InvItem
	item = preload("res://Assets/Inventory/Items/strawberrybanbans.tres")
	player.inventory.insert(item)
	player.inventory.beatGrandma = true
	emit_signal("game_finished", win_state)
	pass

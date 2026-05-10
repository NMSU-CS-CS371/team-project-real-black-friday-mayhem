extends Node2D
@onready var player = get_tree().get_root().get_child(2).player
signal game_finished(result)

func _ready() -> void:
	$Camera2D.make_current()
	pass

func emit_gamestate(win_state : String):
	if win_state == "win":
		var item : InvItem
		item = preload("res://Assets/Inventory/Items/strawberrybanbans.tres")
		player.inventory.insert(item)
		player.inventory.beatGrandma = true
	emit_signal("game_finished", win_state)
	pass

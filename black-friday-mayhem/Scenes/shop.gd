extends Node2D

@onready var SceneTransition = $SceneTransition/AnimationPlayer
var itemsRemoved: int = 0
var totalItems: int = 8

# called upon entering the scene
func _ready() -> void:
	SceneTransition.get_parent().get_node("ColorRect").color.a = 255
	SceneTransition.play("fade_out")

# called every frame
func _process(_delta: float) -> void:
	# if all the items have exited the tree, the minigame is over
	if itemsRemoved >= totalItems:
		minigameOver()
		# don't keep triggering minigameOver() during scene transition
		itemsRemoved = 0

# called every time an item is removed
func _on_item_exiting() -> void:
	itemsRemoved += 1

func minigameOver() -> void:
	await get_tree().create_timer(0.5).timeout
	print("exiting minigame...")
	SceneTransition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://world.tscn")
	

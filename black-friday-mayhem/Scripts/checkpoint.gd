@tool
extends "res://Scripts/obstacle_base.gd"

@onready var SceneTransition = $SceneTransition/AnimationPlayer
enum type {SHOP, RESULTS}
enum shop {GAME_SLOP,HINDS_NOBLE,JKNICKELS,STACYS,RADIO_SHACK,DEBATE}
@export var checkpointType: type 
@export var shopName: shop
var shopScenes = [preload("res://Scenes/Shopping/Shopping3/shopping3.tscn")]
#var shopScenes = [preload("res://Scenes/Shopping/Shopping1/shopping1.tscn"), preload("res://Scenes/Shopping/Shopping2/shopping2.tscn"), preload("res://Scenes/Shopping/Shopping3/shopping3.tscn")]
var resultScreen = preload("res://Scenes/results_screen.tscn")

func _ready() -> void:
	# Apply initial size and color when the scene loads
	_apply_size()
	_apply_color()
	# Connect the TriggerZone's body_entered signal to our handler (runtime only)
	if not Engine.is_editor_hint():
		$TriggerZone.body_entered.connect(_on_trigger_zone_body_entered)

# Fires the player_entered signal when a body enters the trigger zone
# Only responds to nodes in the "player" group to avoid false triggers
func _on_trigger_zone_body_entered(body: Node3D) -> void:
	print("collision!")
	$SceneTransition/ColorRect.visible = true
	if body.is_in_group("player"):
		player_entered.emit()
		SceneTransition.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		
		var target
		# Change scene depending on checkpoint type
		match checkpointType:
			type.SHOP:
				target = shopScenes.pick_random().instantiate()
				add_child(target)
				target.connect("shop_finished", Callable(self, "_on_shopping_minigame_finished"))
			type.RESULTS:
				target = resultScreen.instantiate()
				add_child(target)
		$SceneTransition/ColorRect.visible = false

func _on_shopping_minigame_finished():
	print("reached shopping minigame finished")
	SceneTransition.get_parent().get_node("ColorRect").visible = true
	SceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	SceneTransition.get_parent().get_node("ColorRect").visible = false

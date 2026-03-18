extends "res://Scripts/obstacle_base.gd"

@onready var SceneTransition = $SceneTransition/AnimationPlayer
var shopScenes = ["res://Scenes/shop.tscn", "res://Scenes/Shopping2/shopping2.tscn"]

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
	if body.is_in_group("player"):
		player_entered.emit()
		SceneTransition.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		# Change scene to shop scene
		get_tree().change_scene_to_file(shopScenes.pick_random())

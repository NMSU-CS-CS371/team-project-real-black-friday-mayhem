extends Node2D

@onready var player = get_parent().get_parent().player
@onready var SceneTransition = $SceneTransition/AnimationPlayer
@onready var walletLabel = $WalletLabel
var itemsRemoved: int = 0
var totalItems: int = 6
signal shop_finished

# called upon entering the scene
func _ready() -> void:
	update_wallet_label()
	
	# finish transitioning scene
	SceneTransition.get_parent().get_node("ColorRect").color.a = 255
	SceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	$SceneTransition/ColorRect.visible = false

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
	update_wallet_label()

func minigameOver() -> void:
	# reactivate rectangle used for transition animation
	$SceneTransition/ColorRect.visible = true
	
	# wait a little before beginning scene transition
	await get_tree().create_timer(0.5).timeout
	print("exiting minigame...")
	
	# begin scene transition
	SceneTransition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	emit_signal("shop_finished")
	queue_free()
	

# update label with wallet balance
func update_wallet_label():
	if player.inventory.wallet < 0:
		walletLabel.text = "-$" + str(abs(player.inventory.wallet))
		walletLabel.add_theme_color_override("font_color", Color(1,0,0,1))
	else:
		walletLabel.text = "$" + str(player.inventory.wallet)
		walletLabel.add_theme_color_override("font_color", Color(1,1,1,1))

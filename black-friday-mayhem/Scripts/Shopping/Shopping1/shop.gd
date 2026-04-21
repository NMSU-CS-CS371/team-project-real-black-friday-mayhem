extends Node2D

@onready var player = get_parent().get_parent().player
@onready var checkpoint = get_parent()
@onready var SceneTransition = $SceneTransition/AnimationPlayer
@onready var walletLabel = $WalletLabel
var itemsRemoved: int = 0
var totalItems: int = 6
signal shop_finished

# called upon entering the scene
func _ready() -> void:
	update_wallet_label()
	reskin_background()
	
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
	

# reskins shop depending on which shop the player entered
func reskin_background():
	match checkpoint.shopName:
		checkpoint.shop.GAME_SLOP:
			$Background.texture = load("res://Assets/Textures/gameslop_shelf.jpg")
			print("game slop")
		checkpoint.shop.JKNICKELS:
			$Background.texture = load("res://Assets/Textures/stacys_jknickels_shelf.png")
		checkpoint.shop.HINDS_NOBLE:
			$Background.texture = load("res://Assets/Textures/hinds_noble_shelf.png")
		checkpoint.shop.RADIO_SHACK:
			$Background.texture = load("res://Assets/Textures/shelf.jpg")
		checkpoint.shop.STACYS:
			$Background.texture = load("res://Assets/Textures/stacys_jknickels_shelf.png")
		checkpoint.shop.DEBATE:
			$Background.texture = load("res://Assets/Textures/debate_shelf.png")
		_:
			print("error: unknown shop in reskin_background()")

# update label with wallet balance
func update_wallet_label():
	if player.inventory.wallet < 0:
		walletLabel.text = "-$" + str(abs(player.inventory.wallet))
		walletLabel.add_theme_color_override("font_color", Color(1,0,0,1))
	else:
		walletLabel.text = "$" + str(player.inventory.wallet)
		walletLabel.add_theme_color_override("font_color", Color(1,1,1,1))

extends Node2D

@onready var playerInventory = get_parent().get_parent().player.inventory
@onready var sceneTransition = $SceneTransition/AnimationPlayer
@onready var anim = $AnimationPlayer
@onready var highlight = $ResultsHighlight
@onready var moneySavedLabel = $MoneySaved
@onready var moneyLeftLabel = $MoneyLeft
@onready var scalper = $ScalperReward
@onready var grandma = $GrandmaReward
@onready var karen = $KarenReward

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# update label text
	if playerInventory.wallet < 0:
		moneyLeftLabel.text = "Money: -$"+str(abs(playerInventory.wallet))
		moneyLeftLabel.add_theme_color_override("font_color", Color(1,0,0,1))
	else:
		moneyLeftLabel.text = "Money: $"+str(playerInventory.wallet)
		moneyLeftLabel.add_theme_color_override("font_color", Color(1,1,1,1))
	moneySavedLabel.text = "Money SAVED: $"+str(playerInventory.moneySaved)
	
	# finish transitioning scene
	sceneTransition.get_parent().get_node("ColorRect").color.a = 255
	sceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	
	reveal_special_items()
	
	# finished loading, send inventory to highlight
	highlight.initiate(playerInventory)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reveal_special_items():
	if (playerInventory.beatScalper):
		anim.play("scalper_get")
		$ScalperExplosion.play("default")
		await anim.animation_finished
	if (playerInventory.beatGrandma):
		anim.play("grandma_get")
		$GrandmaExplosion.play("default")
		await anim.animation_finished
	if (playerInventory.beatKaren):
		anim.play("karen_get")
		$KarenExplosion.play("default")
	
func _on_play_pressed():
	# reset inventory
	playerInventory.reset()
	
	# begin scene transition
	sceneTransition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_menu_pressed():
	# reset inventory
	playerInventory.reset()
	
	# begin scene transition
	sceneTransition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

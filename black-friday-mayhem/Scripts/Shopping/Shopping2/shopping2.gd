extends Node2D #Hand Mini Game
#this is the main mini game node which starts the game 
#and connects everything together
#

@onready var SceneTransition = $SceneTransition/AnimationPlayer
@onready var player = get_tree().root.get_child(1).player
enum GameState{IDLE, RUNNING, FINISHED}
var state: GameState = GameState.IDLE
var items: Array[Node2D] = []
@export var wallet_label: Label
signal shop_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_wallet_label()
	# finish transitioning scene
	SceneTransition.get_parent().get_node("ColorRect").color.a = 255
	SceneTransition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	
	# deactivate rectangle used for transition animation
	# to avoid interfering with the minigame
	$SceneTransition/ColorRect.visible = false
	
	print("Mini-game ready")#print to make sure Mini Game Scene is running
	start_game()#start the game

#start game function to start running the mini game
func start_game():
	state = GameState.RUNNING # change game state to running 
	#$Background.show()
	$GameTimer.start()
	print("Mini-game started") #print for debuging
	
func end_game():
	state = GameState.FINISHED
	print("GAME OVER")
	
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
	
	
#function is for other scenes to know if the game is running 
func is_running() -> bool:
	return state == GameState.RUNNING #return if the game state is running
	
#this is to give a random item to whoever calls it (hand spawner)
func choose_random_item() -> Node2D:
	if items.is_empty():
		return null
	return items.pick_random()
	
#function to register items for mini game
func register_item(item: Node2D) -> void:
	items.append(item)

#function to unregister items for mini game
func unregister_item(item: Node2D) -> void:
	items.erase(item)
	
# update label with wallet balance
func update_wallet_label():
	if player.inventory.wallet < 0:
		wallet_label.text = "-$" + str(abs(player.inventory.wallet))
		wallet_label.add_theme_color_override("font_color", Color(1,0,0,1))
	else:
		wallet_label.text = "$" + str(player.inventory.wallet)
		wallet_label.add_theme_color_override("font_color", Color(1,1,1,1))
#function for when the game timer runs out
func _on_game_timer_timeout() -> void:
	print("TIMES UP")
	end_game()
	

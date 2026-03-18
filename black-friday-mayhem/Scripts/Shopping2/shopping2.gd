extends Node2D #Hand Mini Game
#this is the main mini game node which starts the game 
#and connects everything together
#

enum GameState{IDLE, RUNNING, FINISHED}
var state: GameState = GameState.IDLE
var items: Array[Node2D] = []
var score: = 0
@export var score_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Mini-game ready")#print to make sure Mini Game Scene is running
	start_game()#start the game

#start game function to start running the mini game
func start_game():
	state = GameState.RUNNING # change game state to running 
	#$Background.show()
	$GameTimer.start()
	print("Mini-game started") #print for debuging
	
func end_game():
	print("GAME OVER")
	get_tree().quit()
	#Quit game
	#go to main menu
	
	
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
	
#function will add points to the score
func add_score(points):
	score += points
	score_label.text = "" + str(score)
	print ("Score: ", score)
	
#function for when the game timer runs out
func _on_game_timer_timeout() -> void:
	print("TIMES UP")
	end_game()
	

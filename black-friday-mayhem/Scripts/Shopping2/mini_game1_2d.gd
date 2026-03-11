extends Node2D #Hand Mini Game

enum GameState{IDLE, RUNNING, FINISHED}
var state: GameState = GameState.IDLE
var items: Array[Node2D] = []#
var score: = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Mini-game ready")#print to make sure Mini Game Scene is running
	start_game()#start the game

#start game function to start running the mini game
func start_game():
	state = GameState.RUNNING # change game state to running 
	print("Mini-game started") #print for debuging
	
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
	
func add_score(points):
	score += points
	print ("Score: ", score)

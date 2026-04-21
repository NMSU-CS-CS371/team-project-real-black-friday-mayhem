extends Node2D

@onready var player = get_parent().get_parent().player
@onready var invContainer = get_parent().get_parent().get_node("CenterContainer")
signal game_finished(result)
var texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invContainer.visible = false
	$Background.hide()
	$Karen.hide()
	$Item.hide()
	$ProgressBar.hide()
	$ProgressBar.max_value = 400
	$ProgressBar.value = 150
	$Baby.hide()
	$BabyKick.hide()
	$Kid.hide()
	$KidKick.hide()
	texture = player.inventory.getItem()
	if texture != null :
		$Item.texture = texture.sprite
	else :
		invContainer.visible = true
		queue_free()
		
	#before I start the game I need a transition sceen with story 
	#and instructions on how to play game
	startgame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#need to add an if statement that if the item gets to a certain point the game ends
	if $ProgressBar.value <= 0 || $ProgressBar.value >= 400 :
		defeated()
	else :
		$ProgressBar.value += 0.4

func startgame() :
	#set bool to true that the game has started letting the procces func know it can start going
	$Background.show()
	$Karen.show()
	$Item.show()
	$ProgressBar.show()
	$AnimationPlayer.play("Shake")
	

func defeated():
	invContainer.visible = true
	player.controlAllowed = true
	emit_signal("game_finished", "win")
	player.inventory.remove(texture)
	queue_free()
	#var item: InvItem
	#item = load("res://Assets/Inventory/Items/palcomon_cards.tres")
	#player.inventory.insert(item)
	#player.inventory.beatKaren = true
	#player.controlAllowed = true
	
	
#used for when the spacebar is interacted with
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") :
		$ProgressBar.value += -10
		 
		

extends AnimatedSprite2D

var health = 100
var isDodging : bool = false
@export var Grandma : Node2D
@export var MAX_HEALTH : float
#Keeps track of how much effort the player should put in to get up
var effort = 8
#how many times the player has clicked when knocked out
var tries = 0
#keeps track of how many times player has fainted
var faints = 0
#when the player gets up, how much is taken from the health (multiplied by faints)
var penalties = 20

#keeps track if the player is knocked out
var isKnockedOut = false

func hit():
	if health > 0:
		Grandma.take_damage()
	else:
		tries += 1
		pass
	if effort < tries:
		health = MAX_HEALTH - (faints * penalties)
		tries = 0
		effort += 5
		isKnockedOut = false
		print("and he's back in the game!!")
		pass
	pass

func apply_damage():
	if !isDodging and health > 0:
		health = health - 99
		print("took 99 damage")
		pass
	if !isKnockedOut and health < 0:
		isKnockedOut = true
		health = 0
		faints += 1
		print("knocked out")
	pass	
	print("health is ", health)

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Left"):
		isDodging = true
		print("dodging")
		pass
	if event.is_action_pressed("Right"):
		isDodging = true
		print("dodging")
		pass
	
	#Ideally, stopping after animation
	if event.is_action_released("Left"):
		isDodging = false
		print("stopped")
		pass
	if event.is_action_released("Right"):
		isDodging = false
		print("stopped")
		pass
		
	if event.is_action_pressed("click"):
		hit()
		print("hit")
		pass
	
	pass

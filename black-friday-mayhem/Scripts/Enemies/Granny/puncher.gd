extends AnimatedSprite2D

signal knockedOut
signal recovered

var health = 100
var isDodging : bool = false
var isHoldingUP : bool = false
@onready var player = get_tree().root.get_child(1).player
@export var ROOT : Node2D
@export var Grandma : Node2D
@export var MAX_HEALTH : float
@export var animationPlayer : AnimationPlayer

@export var healthBar : ProgressBar
@export var healthText : Label

@export var damage_value_up : int = 2
@export var damage_value_mid : int = 1
enum punchType {PUNCH_UP, PUNCH_MID}
enum dodgeDirection {DODGE_LEFT, DODGE_RIGHT}
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

func _ready() -> void:
	updateHealth()
	print(player.name)

func updateHealth():
	healthBar.value = health
	healthBar.max_value = MAX_HEALTH
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]

func click():
	var punchtype : String
	if isHoldingUP:
		punchtype = "punch up"
	else:
		punchtype = "punch mid"
	
	if health > 0:
		animationPlayer.play(punchtype)
	else:
		tries += 1
		pass
	var penalizations = (faints * penalties)
	if effort < tries:
		health = MAX_HEALTH - penalizations
		updateHealth()
		tries = 0
		effort += 5
		isKnockedOut = false
		recovered.emit()
		print("and he's back in the game!!")
	if penalizations >= MAX_HEALTH:
		print("GAME OVER")
		knockedOut.emit()
		player.playing_game = false
		player.controlAllowed = true
		ROOT.queue_free()
		AudioManager.resume_main_music()
		pass
	
	pass


func hit(punchtype : punchType):
	var input_dir = Input.get_vector("Left", "Right", "Backward", "Forward")
	if input_dir.y != 0:
		pass
	print(input_dir.y)
	var damageGiven : int
	if punchtype == punchType.PUNCH_UP:
		damageGiven = damage_value_up
		print("up")
	elif punchtype == punchType.PUNCH_MID:
		damageGiven = damage_value_mid
		print("mid")
		pass
	if health > 0:
		Grandma.take_damage(damageGiven)
	pass

func apply_damage(damage_taken : int):
	if !isDodging and health > 0:
		health = health - damage_taken
		#print("took 99 damage")
		pass
	if !isKnockedOut and health < 0:
		isKnockedOut = true
		health = 0
		faints += 1
		print("knocked out")
		knockedOut.emit()
	updateHealth()
	pass	
	print("health is ", health)

func setIsDodging(value : bool):
	isDodging = value
	pass
	
func dodge(dodgetype : dodgeDirection):
	var dodgeString : String
	if dodgetype == dodgeDirection.DODGE_LEFT:
		dodgeString = "dodge left"
		pass
	else:
		dodgeString = "dodge right"
		pass
	if !isKnockedOut:
		animationPlayer.play(dodgeString)
		pass
	pass

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Left"):
		#animationPlayer.play("dodge left")
		dodge(dodgeDirection.DODGE_LEFT)
		pass
	if event.is_action_pressed("Right"):
		dodge(dodgeDirection.DODGE_RIGHT)
		print("dodging")
	
	if event.is_action_pressed("Forward"):
		isHoldingUP = true
		pass
	if event.is_action_released("Forward"):
		isHoldingUP = false

	if event.is_action_pressed("click"):
		click()
		print("click")
		pass
	
	pass

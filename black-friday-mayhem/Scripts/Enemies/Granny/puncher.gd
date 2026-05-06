extends AnimatedSprite2D

signal knockedOut
signal recovered

var health = 100
var isDodging : bool = false
var isHoldingUP : bool = false
@onready var player = get_tree().get_first_node_in_group("Player")
@export var ROOT : Node2D
@export var Grandma : Node2D
@export var MAX_HEALTH : float
@export var animationPlayer : AnimationPlayer

@export var healthBar : ProgressBar
@export var healthText : Label

@export var damage_value_up : int = 2
@export var damage_value_mid : int = 1
@export var laser_health : int

@export var number_card_label : Label
@export var number_card_animator : AnimationPlayer

var card_number : int = 10

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

#keeps track of left punch or right punch
var isLeft : bool = false

#keeps track of the type of punch the player inflicted
var leftPunch : bool = false

var game_end : bool = false

var isInAnimation : bool = false

func _ready() -> void:
	updateHealth()
	#print(player.name)

func updateHealth():
	healthBar.value = health
	healthBar.max_value = MAX_HEALTH
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]

func punch():
	if isHoldingUP:
		animationPlayer.play("punch up")
		return
	
	if isLeft:
		animationPlayer.play("punch_mid_L")
		isLeft = false
	else:
		animationPlayer.play("punch_mid_R")
		isLeft = true
	
	pass

func grandmaPunchType(grandmaLeftPunch : bool):
	leftPunch = grandmaLeftPunch
	pass

func click():
	
	if health > 0:
		isDodging = false
		punch()
		#animationPlayer.play(punchtype)
	elif isKnockedOut:
		if leftPunch:
			animationPlayer.play("strugle_L")
		else:
			animationPlayer.play("strugle_R")
		#tries += 1
		pass
	var penalizations = (faints * penalties)
	if effort < tries:
		health = MAX_HEALTH - penalizations
		updateHealth()
		tries = 0
		effort += 5
		#this is for when the player gets up
		#not punches
		if leftPunch:
			animationPlayer.play("up_L")
		else:
			animationPlayer.play("up_R")
		isKnockedOut = false
		recovered.emit()
		#stop timer stuff here:
		number_card_animator.play("keep going")
		print("and he's back in the game!!")
	
	# This is the state when the player looses
	if !game_end and penalizations >= MAX_HEALTH:
		#GAME OVER FROM LOST HEALTH
		$"../SoundEffects/beeplate/AnimationPlayer".play("beepend")
		game_end = true
		card_number = -2
		number_card_label.text = "KO"
		number_card_animator.play("start")
		$Timer.wait_time = 6
		$Timer.start()
		pass
	
	pass

func game_over(game_state : String):
	print("GAME OVER")
	knockedOut.emit()
	player.controlAllowed = true
	player.playing_game = false
	AudioManager.resume_main_music()
	ROOT.emit_gamestate(game_state)
	ROOT.queue_free()

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
	
func strugle():
	tries += 1
	pass

func apply_damage(damage_taken : int):
	if !isDodging and health > 0:
		if Grandma.weAttackinWithTheLazersYo == false:
			$"../SoundEffects/GrandmaHit".play()
		else:
			$"../SoundEffects/Grandmapewpew".play()
		health = health - damage_taken
	var temp_faints = faints + 1
	if !game_end and (temp_faints * penalties) >= MAX_HEALTH:
		#GAME OVER FROM LOST HEALTH
		$"../SoundEffects/beeplate/AnimationPlayer".play("beepend")
		game_end = true
		card_number = -2
		number_card_label.text = "KO"
		number_card_animator.play("start")
		$Timer.wait_time = 5
		$Timer.start()
	
	if !isKnockedOut and health <= 0:
		isKnockedOut = true
		$Playerhit.play()
		health = 0
		faints += 1
		print("knocked out")
		knockedOut.emit()
		if !game_end:
			card_number = 10
			number_card_label.text = "%d" % [card_number]
			number_card_animator.play("start")
			$Timer.start()
		#keep this in here! This is the animation for when the player is hit down...
		if leftPunch:
			animationPlayer.play("down_L")
		else:
			animationPlayer.play("down_R")
	updateHealth()	

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

func changeIsInAnimation(value : bool):
	isInAnimation = value
	pass

func _input(event: InputEvent) -> void:
	if game_end:
		return
	
	if event.is_action_pressed("Left"):
		#animationPlayer.play("dodge left")
		isInAnimation = false
		dodge(dodgeDirection.DODGE_LEFT)
		$dodge.play()
		pass
	if event.is_action_pressed("Right"):
		isInAnimation = false
		dodge(dodgeDirection.DODGE_RIGHT)
		$dodge.play()
		print("dodging")
	
	if event.is_action_pressed("Forward"):
		isHoldingUP = true
		pass
	if event.is_action_released("Forward"):
		isHoldingUP = false
	if event.is_action_pressed("ui_accept"):
		if !isInAnimation:
			click()
		print("space click")
	if event.is_action_pressed("click"):
		click()
		isInAnimation = false
		print("click")
		pass
	
	pass

func update_text():
	card_number -= 1
	number_card_label.text = "%d" % [card_number]
	number_card_animator.play("next")
	pass

func _on_timer_timeout() -> void:
	print("updated text: ", card_number)
	if !isKnockedOut: 
		return
	#decrease time limit
	if card_number == -2:
		#GAME OVER FROM GIVE UP
		game_over("lose")
		return
	if card_number > 4:
		$"../SoundEffects/beepearly".play()
	if card_number >= 0:
		update_text()
	if card_number <= 3 && card_number >= 0:
		$"../SoundEffects/beeplate".play()
		pass
	if card_number == 0:
		$"../SoundEffects/beeplate/AnimationPlayer".play("loop")
	if card_number == -1:
		$"../SoundEffects/beeplate/AnimationPlayer".play("beepend")
		number_card_label.text = "TKO"
		number_card_animator.play("next")
		
	$Timer.wait_time = 1
	$Timer.start()
	# check it that time limit is 0
	# if 0, end game
	pass # Replace with function body.

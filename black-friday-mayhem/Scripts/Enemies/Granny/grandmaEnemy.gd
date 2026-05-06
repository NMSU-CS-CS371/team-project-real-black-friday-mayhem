extends AnimatedSprite2D

@export var ROOT : Node2D
@export var player : Node2D
@export var MAX_HEALTH : int
@export var laser_health : int
# this is the value if the player get's grandma to this health 
# before the first punch
# (IE, make the game even harder if they're too good
@export var skill_check_health : int = 160
var health = 100
@export var animationPlayer : AnimationPlayer
@export var healthBar : ProgressBar
@export var healthText : Label

var willGoForKill : bool = true
var murderObliteration : bool = false

@export var damage : int = 99
var isLeft = false

var skillCheck = false

var isPlayingAudio : bool = false

var weAttackinWithTheLazersYo : bool = false

func _ready() -> void:
	health = MAX_HEALTH
	healthBar.max_value = MAX_HEALTH
	healthBar.value = health
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]
	animationPlayer.play("startup")
	pass

func apply_force():
	$SoundEffects/hit.play()
	player.apply_damage(damage)
	pass
func apply_custom_force(strength : int):
	player.apply_damage(strength)
	pass

func take_damage(damage_taken : int):
	health = health - damage_taken
	healthBar.value = health
	healthBar.max_value = MAX_HEALTH
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]
	$SoundEffects/hit.play()
	print("grandma health: ", health)
	# enable laser beam eyes
	if !murderObliteration and health <= laser_health:
		murderObliteration = true
		animationPlayer.play("ANGER")
		pass
	if health <= 0:
		$"../VoiceLines/Insults".stop()
		healthText.text = "HP 0/%d" % [MAX_HEALTH]
		stopDisrespectingMyGangsYo()
		player.game_end = true
		print("GAME WIN!")
		animationPlayer.play("granniesdead")
	pass

func grannydied():
	player.player.playing_game = false
	player.player.controlAllowed = true
	AudioManager.resume_main_music()
	ROOT.emit_gamestate("win")
	ROOT.queue_free()

func stopDisrespectingMyGangsYo():
	#print("yup")
	willGoForKill = false
	pass
	
func decimation():
	willGoForKill = true
	pass

func _on_timer_timeout() -> void:
	if !skillCheck:
		if health < skill_check_health:
			murderObliteration = true
			animationPlayer.play("ANGER")
		skillCheck = true
	if willGoForKill:
		var time = randf_range(1.5, 3.5)
		if murderObliteration:
				time = randf_range(1, 1.85)
		$Timer.wait_time = time
		chooseAttackStyle()
		#animationPlayer.play("punch_start")
	pass # Replace with function body.

func chooseAttackStyle():
	var randOption = randi_range(0, 2)
	match randOption:
		2:
			if murderObliteration:
				weAttackinWithTheLazersYo = true
				animationPlayer.play("laser_attack")
			else:
				weAttackinWithTheLazersYo = false
				punchDir()
		0: 
			if murderObliteration:
				weAttackinWithTheLazersYo = true
				animationPlayer.play("laser_attack")
			else:
				weAttackinWithTheLazersYo = false
				punchDir()
		1:
			weAttackinWithTheLazersYo = false
			punchDir()
			pass	
	pass

func punchDir():
	if murderObliteration:
		if isLeft:
			animationPlayer.play("A_PUNCH_L")
			player.grandmaPunchType(true)
			isLeft = false
		
		else:
			animationPlayer.play("A_PUNCH_R")
			player.grandmaPunchType(false)
			isLeft = true
		return
	
	if isLeft:
		animationPlayer.play("PUNCH_L")
		player.grandmaPunchType(true)
		isLeft = false
		pass
	else:
		animationPlayer.play("PUNCH_R")
		player.grandmaPunchType(false)
		isLeft = true
		pass

func playInsults():
	if !isPlayingAudio:
		$"../VoiceLines/Insults".play()
		isPlayingAudio = true
	
	pass


func _on_insults_finished() -> void:
	isPlayingAudio = false
	pass # Replace with function body.

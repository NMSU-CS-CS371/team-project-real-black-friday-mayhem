extends AnimatedSprite2D

@export var ROOT : Node2D
@export var player : Node2D
@export var MAX_HEALTH : int
@export var laser_health : int
var health = 100
@export var animationPlayer : AnimationPlayer
@export var healthBar : ProgressBar
@export var healthText : Label

var willGoForKill : bool = true
var murderObliteration : bool = false
var laserPhaseTransition : bool = false

@export var damage : int = 99
var isLeft = false

var skillCheck = false

func _ready() -> void:
	health = MAX_HEALTH
	healthBar.max_value = MAX_HEALTH
	healthBar.value = health
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]
	pass

func apply_force():
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
	print("grandma health: ", health)
	# enable laser beam eyes
	if !laserPhaseTransition and health <= laser_health:
		murderObliteration = true
		animationPlayer.play("ANGER")
		laserPhaseTransition = true
		pass
	if health <= 0:
		print("GAME WIN!")
		player.player.playing_game = false
		player.player.controlAllowed = true
		AudioManager.resume_main_music()
		ROOT.emit_gamestate("win")
		ROOT.queue_free()
	pass

func stopDisrespectingMyGangsYo():
	#print("yup")
	willGoForKill = false
	pass
	
func decimation():
	willGoForKill = true
	pass

func _on_timer_timeout() -> void:
	#if !skillCheck:
		#if health < 160:
			#player.
	if willGoForKill:
		$Timer.wait_time = randf_range(1.5, 3.5)
		if murderObliteration:
				$Timer.wait_time = randf_range(1, 2)
		chooseAttackStyle()
		#animationPlayer.play("punch_start")
	pass # Replace with function body.

func chooseAttackStyle():
	var randOption = randi_range(0, 2)
	match randOption:
		2:
			if murderObliteration:
				animationPlayer.play("laser_attack")
			else:
				punchDir()
		0: 
			if murderObliteration:
				animationPlayer.play("laser_attack")
			else:
				punchDir()
		1:
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
	pass

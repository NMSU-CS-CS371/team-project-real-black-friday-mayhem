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

@export var damage : int = 99

func _ready() -> void:
	health = MAX_HEALTH
	healthBar.max_value = MAX_HEALTH
	healthBar.value = health
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]
	pass

func apply_force():
	player.apply_damage(damage)
	pass

func take_damage(damage_taken : int):
	health = health - damage_taken
	healthBar.value = health
	healthBar.max_value = MAX_HEALTH
	healthText.text = "HP %d/%d" % [health, MAX_HEALTH]
	print("grandma health: ", health)
	# enable laser beam eyes
	if health <= laser_health:
		murderObliteration = true
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
	if willGoForKill:
		$Timer.wait_time = randf_range(1.5, 3.5)
		chooseAttackStyle()
		#animationPlayer.play("punch_start")
	pass # Replace with function body.

func chooseAttackStyle():
	var randOption = randi_range(0, 1)
	match randOption:
		0: 
			if murderObliteration:
				print("eye ball laser")
				# animationPlayer.play("eyes obliteration")
				pass
			else:
				animationPlayer.play("punch_start")
			pass
		1:
			animationPlayer.play("punch_start")
			pass	
	pass

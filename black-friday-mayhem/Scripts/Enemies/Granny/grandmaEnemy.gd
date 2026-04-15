extends AnimatedSprite2D

@export var ROOT : Node2D
@export var player : Node2D
@export var MAX_HEALTH : int
var health = 100
@export var animationPlayer : AnimationPlayer
@export var healthBar : ProgressBar
@export var healthText : Label

var willGoForKill : bool = true

@export var damage : int = 99

func _ready() -> void:
	health = MAX_HEALTH
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
	if health < 0:
		print("GAME WIN!")
		player.player.playing_game = false
		player.player.controlAllowed = true
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
		animationPlayer.play("punch_start")
	pass # Replace with function body.

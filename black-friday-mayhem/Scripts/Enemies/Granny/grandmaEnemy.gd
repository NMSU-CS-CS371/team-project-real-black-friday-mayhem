extends AnimatedSprite2D

@export var player : Node2D
var health = 100

func apply_force():
	player.apply_damage()
	pass

func take_damage():
	health = health - 0.5
	print("grandma health: ", health)
	pass

func _on_timer_timeout() -> void:
	$"../AnimationPlayer".play("punch_start")
	pass # Replace with function body.

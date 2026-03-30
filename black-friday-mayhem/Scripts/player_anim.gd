extends AnimatedSprite3D

@onready var player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.isMoving:
		if player.rotationChange == 0:
			if player.isMovingBackward:
				play_if_not("front_braking")
			else:
				play_if_not("front")
		if player.rotationChange > 0:
			if player.isMovingBackward:
				play_if_not("left_braking")
			else:
				play_if_not("left")
		if player.rotationChange < 0:
			if player.isMovingBackward:
				play_if_not("right_braking")
			else:
				play_if_not("right")
	else:
		if not player.isTurning:
			play_if_not("idle")
		elif player.rotationChange > 0:
			play_if_not("left_tilt")
		elif player.rotationChange < 0:
			play_if_not("right_tilt")

func play_if_not(anim):
	if animation != anim:
		play(anim)

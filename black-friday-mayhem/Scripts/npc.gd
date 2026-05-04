extends BaseCharacter

var target_position: Vector3
var move_speed := 2.5
var move_range := 10.0
var wait_time := 0.0

var knocked_down := false
var fall_speed := 6.0
var fall_angle := deg_to_rad(90)

var down_time := 3.0
var down_timer := 0.0

var standing_y := 0.0
var fallen_y_offset := -0.7
@export var sprit : GeometryInstance3D
var mask

func _ready():
	mask = sprit.material_override
	randomize()
	$AnimatedSprite3D.play("default")
	$AnimatedSprite3D/Sprite3D/SubViewport/AnimatedSprite2D.play("default")
	
	standing_y = $AnimatedSprite3D.position.y
	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	
	mask.billboard_mode = 1
	mask.billboard_keep_scale = true
	# Area3D player hit detection
	if has_node("HitboxArea3D"):
		$HitboxArea3D.body_entered.connect(_on_hitbox_body_entered)

	pick_new_target()

func _physics_process(delta):
	if knocked_down:
		velocity = Vector3.ZERO

		$AnimatedSprite3D.rotation.z = move_toward(
			$AnimatedSprite3D.rotation.z,
			fall_angle,
			fall_speed * delta
		)

		$AnimatedSprite3D.position.y = move_toward(
			$AnimatedSprite3D.position.y,
			standing_y + fallen_y_offset,
			2.5 * delta
		)

		down_timer -= delta

		if down_timer <= 0.0:
			get_back_up()

		return

	# Standing NPC keeps facing camera/player.
	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	mask.billboard_mode = 1
	mask.billboard_keep_scale = true
	
	if wait_time > 0.0:
		wait_time -= delta
		velocity = Vector3.ZERO
		apply_movement_and_animation(delta)
		return

	var direction = global_position.direction_to(target_position)
	direction.y = 0
	velocity = direction * move_speed

	apply_movement_and_animation(delta)

	# Backup collision check, but only player can knock them down.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if is_player(body):
			knock_down()
			return

	if global_position.distance_to(target_position) < 0.5:
		wait_time = randf_range(0.5, 2.0)
		pick_new_target()

func _on_hitbox_body_entered(body):
	if knocked_down:
		return

	if is_player(body):
		knock_down()

func is_player(body) -> bool:
	if body == null:
		return false

	return body.name == "Player" or body.is_in_group("player")

func knock_down():
	print("NPC knocked down")

	knocked_down = true
	velocity = Vector3.ZERO
	down_timer = down_time

	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	mask.billboard_mode = 0
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true

func get_back_up():
	print("NPC got back up")

	knocked_down = false
	velocity = Vector3.ZERO
	wait_time = randf_range(0.5, 1.5)

	$AnimatedSprite3D.rotation.z = 0.0
	$AnimatedSprite3D.position.y = standing_y
	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	
	mask.billboard_mode = 1
	mask.billboard_keep_scale = true

	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = false

	pick_new_target()

func pick_new_target():
	var offset_x = randf_range(-move_range, move_range)
	var offset_z = randf_range(-move_range, move_range)

	target_position = Vector3(
		global_position.x + offset_x,
		global_position.y,
		global_position.z + offset_z
	)

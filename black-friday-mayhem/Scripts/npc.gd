extends BaseCharacter

var target_position: Vector3
var home_position: Vector3

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

var voices_muted := false

@export var sprit: GeometryInstance3D
var mask

func _ready():
	add_to_group("npc")
	
	home_position = global_position

	mask = sprit.material_override
	randomize()

	$AnimatedSprite3D.play("default")
	$AnimatedSprite3D/Sprite3D/SubViewport/AnimatedSprite2D.play("default")

	standing_y = $AnimatedSprite3D.position.y
	$AnimatedSprite3D.billboard = BaseMaterial3D.BILLBOARD_ENABLED

	mask.billboard_mode = 1
	mask.billboard_keep_scale = true

	if has_node("HitboxArea3D"):
		$HitboxArea3D.body_entered.connect(_on_hitbox_body_entered)
		$HitboxArea3D.body_shape_entered.connect(_on_hitbox_body_shape_entered)

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

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if is_player(body):
			knock_down()
			return

		wait_time = randf_range(0.2, 0.6)
		pick_new_target()
		return

	if global_position.distance_to(target_position) < 0.5:
		wait_time = randf_range(0.5, 2.0)
		pick_new_target()


func try_knock_down(body: Node3D) -> void:
	if knocked_down:
		return

	if is_player(body):
		knock_down()


func _on_hitbox_body_entered(body: Node3D) -> void:
	try_knock_down(body)


func _on_hitbox_body_shape_entered(
	_body_rid: RID,
	body: Node3D,
	_body_shape_index: int,
	_local_shape_index: int
) -> void:
	try_knock_down(body)


func is_player(body) -> bool:
	if body == null:
		return false

	return body.name == "Player" or body.is_in_group("player") or body.is_in_group("Player")


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
		home_position.x + offset_x,
		global_position.y,
		home_position.z + offset_z
	)


func _on_detection_body_entered(body: Node3D) -> void:
	if voices_muted:
		return

	if is_player(body):
		$Lines.volume_db = 6

		if $Lines2.playing:
			$Lines2.stop()

		if not $Lines.playing:
			$Lines.play()


func _on_detection_body_exited(body: Node3D) -> void:
	if voices_muted:
		return

	if is_player(body):
		if $Lines.playing:
			$Lines.volume_db = 2


func _on_detection_2_body_entered(body: Node3D) -> void:
	if voices_muted:
		return

	if is_player(body):
		if $Lines.playing:
			return

		$Lines2.volume_db = 4
		if not $Lines2.playing:
			$Lines2.play()


func _on_detection_2_body_exited(body: Node3D) -> void:
	if voices_muted:
		return

	if is_player(body):
		if $Lines2.playing:
			$Lines2.volume_db = 1

func mute_voice_lines() -> void:
	voices_muted = true

	if has_node("Lines") and $Lines.playing:
		$Lines.stop()

	if has_node("Lines2") and $Lines2.playing:
		$Lines2.stop()


func unmute_voice_lines() -> void:
	voices_muted = false

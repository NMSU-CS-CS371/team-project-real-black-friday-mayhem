extends BaseCharacter

#movement varibles
@export var speed := 1.0
@export var pause_time := 1.5
@export var move_time := 5.0
var moving = true
var time = 0.0
var radius = 5.0
var angle = 0.0
var center : Vector3

#mini game varibles
var is_defeated = false
var playing_game = false

func _ready() -> void:
	center = global_position  # starting point = center of circle
	cycle()

func cycle():
	while true:
		# Move phase
		moving = true
		await get_tree().create_timer(move_time).timeout
		# Pause phase
		moving = false
		if not is_defeated and not playing_game:
			sprite.play("idle")
		await get_tree().create_timer(pause_time).timeout

func _physics_process(delta: float) -> void:
	if is_defeated :
		sprite.offset.y = 7
		velocity = Vector3.ZERO
	elif playing_game :
		sprite.play("idle")
		velocity = Vector3.ZERO
	else :
		sprite.offset.y = 15
		if moving:
			#-move-
			angle += speed * delta
			
			#calculate new position
			var new_x = center.x + cos(angle) * radius
			var new_z = center.z + sin(angle) * radius
			var target_pos = Vector3(new_x, global_position.y, new_z)
			
			var direction = (target_pos - global_position)
			direction.y = 0
			velocity = direction / delta
		else:
			velocity = Vector3.ZERO
			
	apply_movement_and_animation(delta)
	
# moved movement and animation logic to entity_movement.gd

func _on_hit_box_body_entered(_body: Node3D) -> void:
	print("karen hit")

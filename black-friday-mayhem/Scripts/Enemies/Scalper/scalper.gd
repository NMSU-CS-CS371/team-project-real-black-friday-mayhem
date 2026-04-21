extends EntityMovement

var time = 0.0
var radius = 5.0
var speed = 1.0
var angle = 0.0
var center : Vector3
@export var enemy_type : Node3D
var last_position = Vector3.ZERO
var Palcomon = preload("res://Scenes/Enemies/Scalper/palcomon.tscn")
var is_defeated = false
var playing_game = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_position = global_position
	center = global_position  # starting point = center of circle

func _physics_process(delta: float) -> void:
	if is_defeated:
		sprite.play("defeated")
		sprite.offset.y = 7
		velocity = Vector3.ZERO
	elif playing_game:
		sprite.play("forward")
		velocity = Vector3.ZERO
	else:
		sprite.offset.y = 15
		time += delta * speed
		
		#calculate new position
		var new_x = center.x + cos(time) * radius
		var new_z = center.z + sin(time) * radius
		var target_pos = Vector3(new_x, global_position.y, new_z)
		
		# set velocity to move towards target pos to allow physics collision
		var direction = (target_pos - global_position)
		direction.y = 0
		velocity = direction / delta
	
	apply_movement_and_animation(delta)

# moved movement and animation logic to entity_movement.gd

func _on_hit_box_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player"): # Check if collision is not player
		return
	
	if (is_defeated || playing_game) :
		return
	playing_game = true
	#Tells the player to stop velocity
	if body.has_signal("stop_velocity"):
		body.stop_velocity.emit()
	var battle = Palcomon.instantiate()
	add_child(battle)
	battle.connect("game_finished", Callable(self, "_on_minigame_finished"))
	
func _on_minigame_finished(result):
	if result == "win" :
		is_defeated = true
		print("Enemy defeated")
	playing_game = false

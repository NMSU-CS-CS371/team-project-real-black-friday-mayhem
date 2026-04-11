extends Node3D

var time = 0.0
var radius = 5.0
var speed = 1.0
var angle = 0.0
var center : Vector3
@export var enemy_type : Node3D
var last_position = Vector3.ZERO
@onready var sprite = $AnimatedSprite3D
var Palcomon = preload("res://Scenes/Enemies/Scalper/palcomon.tscn")
var is_defeated = false
var playing_game = false
signal stopVelocity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_position = global_position
	center = global_position  # starting point = center of circle

	# Connect the signal via code



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_defeated :
		$AnimatedSprite3D.play("defeated")
		$AnimatedSprite3D.offset.y = 7
	elif playing_game :
		$AnimatedSprite3D.play("forward")
	else :
		$AnimatedSprite3D.offset.y = 15
		#-move-
		time += delta * speed
		
		#calculate new position
		var new_x = center.x + cos(time) * radius
		var new_z = center.z + sin(time) * radius
		
		global_position.x = new_x
		global_position.z = new_z
		
		update_animation()
		last_position = global_position
	
func _physics_process(_delta: float) -> void:
	if $RayCast3D.is_colliding():
		var floor_height = $RayCast3D.get_collision_point().y
		global_position.y = floor_height
		
		
func update_animation() :
	var direction = global_position - last_position
	
	#prevents tiny jittering movements
	if direction.length() < 0.001 :
		return
		
	#normalize the direction
	direction = direction.normalized()
	
	#decide animation
	if abs(direction.x) > abs(direction.z) :
		if direction.x > 0 :
			play_if_not("right")
		else :
			play_if_not("left")
	else :
		if direction.z > 0 :
			play_if_not("forward")
		else :
			play_if_not("backward")
			
func play_if_not(anim):
	if sprite.animation != anim:
		sprite.play(anim)


func _on_hit_box_body_entered(_body: Node3D) -> void:
	
	if (is_defeated || playing_game) :
		return
	playing_game = true
	#Tells the player to stop velocity
	_body.stop_velocity.emit()
	var battle = Palcomon.instantiate()
	add_child(battle)
	battle.connect("game_finished", Callable(self, "_on_minigame_finished"))
	
func _on_minigame_finished(result):
	if result == "win" :
		is_defeated = true
		playing_game = false
		print("Enemy defeated")
	else :
		playing_game = false
	

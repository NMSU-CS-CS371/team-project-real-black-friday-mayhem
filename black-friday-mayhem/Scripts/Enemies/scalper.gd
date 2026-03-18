extends Node3D

var time = 0.0
var radius = 5.0
var speed = 1.0
var angle = 0.0
var center = Vector3(0,0,0)
var last_position = Vector3.ZERO
@onready var sprite = $AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

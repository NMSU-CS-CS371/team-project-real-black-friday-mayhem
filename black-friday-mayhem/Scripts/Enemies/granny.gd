extends Node3D

#movement varibles
var time = 0.0
var radius = 5.0
var speed = 1.0
var angle = 0.0
var center : Vector3
@export var game : Node3D
var last_position = Vector3.ZERO
@onready var sprite = $AnimatedSprite3D
var is_defeated = false
var playing_game = false
#signal stopVelocity
var hit = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get positions ready
	last_position = global_position
	center = global_position  # starting point = center of circle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_defeated :
		return
	elif playing_game :
		$AnimatedSprite3D.play("Final")
	else :
		$AnimatedSprite3D.offset.y = 0
		#-move-
		time += delta * speed
		
		#calculate new position
		var new_x = center.x + cos(time) * radius
		var new_z = center.z + sin(time) * radius
		
		global_position.x = new_x
		global_position.z = new_z
		
		update_animation()
		last_position = global_position

func play_if_not(anim, flip):
	if sprite.animation != anim:
		if flip :
			sprite.flip_h = true
		else :
			sprite.flip_h = false
		sprite.play(anim)
		
			

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
			if hit == 0 :
				play_if_not("Side1", true)
			if hit == 1 :
				play_if_not("Side2", true)
			if hit >= 2 :
				play_if_not("Side3", true)
		else :
			if hit == 0 :
				play_if_not("Side1", false)
			if hit == 1 :
				play_if_not("Side2", false)
			if hit >= 2 :
				play_if_not("Side3", false)
	else :
		if direction.z > 0 :
			if hit == 0 :
				play_if_not("Front1", false)
			if hit == 1 :
				play_if_not("Front2", false)
			if hit >= 2 :
				play_if_not("Front3", false)
		else :
			play_if_not("Back", false)
			

			


func _on_collision_shape_3d_child_entered_tree(_node: Node) -> void:
	hit += 1
	print("hit grandma")
	

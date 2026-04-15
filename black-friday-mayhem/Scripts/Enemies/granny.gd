extends Node3D

#movement varibles
var time = 0.0
var radius = 5.0
var speed = 0.4
var angle = 0.0
var center : Vector3
@export var game : Node3D
var last_position = Vector3.ZERO
@onready var sprite = $AnimatedSprite3D
@onready var player = get_tree().root.get_child(1).player
var is_defeated = false
var playing_game = false
var punchies = preload("res://Scenes/Enemies/Grandma/punchies.tscn")
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
		#jolena, we don't need this... :face_palm:
		#(if you place them from the folder to the floor, it will just snap in general...)
		
		#what if it does not?
		#(i.e. too small a raycast to hit the floor or the floor is above the enemy
		#plus! It uses too many resources!!
		# I would get it if we only did this once, but it's every frame! We only need to check twice!!
		#(unless we're making [WAFFLES] stairs, then I could definitely see the use...)

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
			

func _on_hit_box_body_entered(body: Node3D) -> void:
	if hit >= 2 && !player.playing_game:
		print("oh heck no")
		player.playing_game = true
		body.stop_velocity.emit()
		var killer_instinct = punchies.instantiate()
		add_child(killer_instinct)
	else:
		hit = hit + 1
		print("sorry.!")
		

#this function is for the textbox when grandma is hit
func when_hit(_num) :
	pass
	#when the granny is hit I want to have you and the grandma stop 
	#and a text box of the grandma and you to be locked in
	#until you tap/press a button
	#wont increase granny hit until text box is closed
	
	#TO DO:
	#write comment that make sense pls ^ 
		

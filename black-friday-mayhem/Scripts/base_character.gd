extends CharacterBody3D
class_name BaseCharacter

@onready var sprite = $AnimatedSprite3D

#boolean if we have a mask
var hasMask : bool = false
#boolean to see if we've looked for the mask
var maskCheck : bool = false
#mask:
var base_mask #IF WE HAD ONE!

func apply_movement_and_animation(_delta: float) -> void:
	# lock their vertical velocity and let the raycast handle floor snapping
	velocity.y = 0
	
	# RayCast gravity fallback
	var ray = get_node_or_null("RayCast3D")
	if ray and ray.is_colliding():
		var floor_height = ray.get_collision_point().y
		global_position.y = floor_height

	# Apply physics movement and update directional animation
	move_and_slide()	
	update_animation()

func update_animation() -> void:
	var dir = velocity
	dir.y = 0 # Ignore vertical movement for animation logic
	
	if dir.length() < 0.1:
		return
		
	dir = dir.normalized()
	
	if not sprite:
		return
		
	# Determine primary axis of movement
	if abs(dir.x) > abs(dir.z):
		if dir.x > 0:
			play_if_not("Right", "right")
		else:
			play_if_not("Left", "left")
	else:
		if dir.z > 0:
			play_if_not("Forward", "forward")
		else:
			play_if_not("Back", "backward", "back")

func play_if_not(anim1: String, anim2: String = "", anim3: String = "") -> void:
	if sprite.sprite_frames.has_animation(anim1):
		if sprite.animation != anim1:
			sprite.play(anim1)
			play_mask(anim1)
	elif anim2 != "" and sprite.sprite_frames.has_animation(anim2):
		if sprite.animation != anim2:
			sprite.play(anim2)
			play_mask(anim2)
	elif anim3 != "" and sprite.sprite_frames.has_animation(anim3):
		if sprite.animation != anim3:
			sprite.play(anim3)
			play_mask(anim3)

func play_mask(anim : String):
	if !maskCheck:
		if get_child(0).get_child(0).get_child(0).get_child(0) != null:
			base_mask = get_child(0).get_child(0).get_child(0).get_child(0)
		if base_mask.name != "AnimatedSprite2D": #yeah.. it's hardcoded...
			base_mask = null
			#print("HELP: ", get_child(0).get_child(0).get_child(0).get_child(0).name)
		else:
			hasMask = true
		maskCheck = true #I'm only checking once dang it!!
		
	if hasMask:
		base_mask.play(anim)

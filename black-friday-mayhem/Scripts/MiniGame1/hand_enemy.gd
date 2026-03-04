extends Node2D #Hand Enemy

#Variables for Hand Movement
#current behavior of the hand
enum HandState {WAITING, MOVING_TO_ITEM}
var state : = HandState.WAITING
#how long the hand pauses at spawn
var wait_time : = 2.0 #seconds to wait when spawned
#Timer counts elapsed time
var wait_timer : = 0.0
#the item the hand will go for
var target_item : Node2D = null
#speed toward item
var move_speed: = 100.0

#Variables for Spawning Hands
var base_position: Vector2
var spawn_side: int
var move_range := 32.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# lock hand to spawn position for edge movement
	base_position = position
	#when area is clicked send a clicked signal 
	$ClickArea.input_event.connect(_on_click_area_input)
	#varible for the center of the screen
	var center = get_viewport_rect().size / 2
	#look_at rotates hand to the center
	look_at(center)	

#function that gets called every frame
func _process(delta):
	#offset for the position
	var offset := sin(Time.get_ticks_msec() / 400.0) * move_range
	# match spawn side (cases)
	match spawn_side:
		0, 1: # TOP or BOTTOM
			position.x = base_position.x + offset
			position.y = base_position.y
		2, 3: # LEFT or RIGHT
			position.y = base_position.y + offset
			position.x = base_position.x
	# Handle waiting and moving toward item
	match state:
		HandState.WAITING:
			wait_timer += delta
			if (wait_timer >= wait_time and target_item):
				state = HandState.MOVING_TO_ITEM
		HandState.MOVING_TO_ITEM:
			if not target_item:
				return
			var direction = (target_item.position - position).normalized()
			position += direction * move_speed * delta
			#if the its moving toware the item then face the item
			if state == HandState.MOVING_TO_ITEM and target_item:
				look_at(target_item.position)

#checks if the hand is clicked
func _on_click_area_input(_viewport, event, _shape_idx):
	#if the mouse clicks on hand delete
	if event is InputEventMouseButton and event.pressed:
		#print("Hand clicked!")
		queue_free()#delete hand

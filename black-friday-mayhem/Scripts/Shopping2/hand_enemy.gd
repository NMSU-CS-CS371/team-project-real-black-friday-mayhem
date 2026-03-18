extends Node2D #Hand Enemy
#on initulization
#will find a target item
#set position
#if clicked will be deleted
#set where the hand looks
#if in item area steal it

#HAND LOGIC
#spawn
#wait
#find item
#move to item
#if on item steal it and disapper
#if item gone go back to starting position

#Variables for Hand Movement
#current behavior of the hand
enum HandState {WAITING, MOVING_TO_ITEM, RETURNING}
var state : = HandState.WAITING
#how long the hand pauses at spawn
var wait_time : = 2.0 #seconds to wait when spawned
#Timer counts elapsed time
var wait_timer : = 0.0
#the item the hand will go for
var target_item : Node2D = null
#speed toward item
var move_speed: = 100.0
var elapsed_time := 0.0

#Variables for Spawning Hands
var base_position: Vector2
var spawn_side: int
var move_range := 32.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#find a target item for the hand
	find_target()
	# lock hand to spawn position for edge movement
	base_position = position
	#when area is clicked send a clicked signal 
	$ClickArea.input_event.connect(_on_click_area_input)
	#varible for the center of the screen
	var center = get_viewport_rect().size / 2
	#look_at rotates hand to the center
	look_at(center)	
	# connect grab detection for items
	$GrabArea.area_entered.connect(_on_grab_area_entered)

#function that gets called every frame
func _process(delta):
	# Handle waiting and moving toward item
	elapsed_time += delta
	match state:
		HandState.WAITING: #waiting
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
			
			#update timer
			wait_timer += delta
			#if timer is greater or equal to the time
			if wait_timer >= wait_time:
				#if target item is not found 
				if not target_item:
					#find a new item
					find_target()
				#if the target is found
				if target_item:
					#move to item
					state = HandState.MOVING_TO_ITEM
		
		HandState.MOVING_TO_ITEM: #moving to item
			if not target_item or not is_instance_valid(target_item):
				state = HandState.RETURNING
				return
			#direction
			var speed_multiplier = 1.0 + (elapsed_time / 5.0)
			var direction = (target_item.position - position).normalized()
			position += direction * move_speed * speed_multiplier * delta

			#if the its moving toware the item then face the item
			look_at(target_item.position)
			
		HandState.RETURNING: #returning
			#direction back to the starting point
			var direction = (base_position - position).normalized()
			position += direction * move_speed * delta

			#if position is close to the start position set to waiting 
			if position.distance_to(base_position) < 5:
				position = base_position
				wait_timer = 0
				find_target()
				state = HandState.WAITING

#checks if the hand is clicked
func _on_click_area_input(_viewport, event, _shape_idx):
	#if the mouse clicks on hand delete
	if event is InputEventMouseButton and event.pressed:
		#print("Hand clicked!")
		queue_free()#delete hand
		
#for finding an item to go for 
func find_target():
	#get items from items group
	var items = get_tree().get_nodes_in_group("items")
	
	#if there are no items 
	if items.size() == 0 :
		#return with no target
		target_item = null
		return
	#else pick a random item
	target_item = items.pick_random()

#it the hand is in the target items collision area
func _on_grab_area_entered(area):
	#if its not moving toward the item return
	if state != HandState.MOVING_TO_ITEM:
		return
	#item area is = to the items root node
	var item = area.get_parent()

#if item is the target item steal it
	if item == target_item:
		steal_item()
		
#steal item
func steal_item():
	#if the target item is not null and is valid
	if target_item and is_instance_valid(target_item):
		#delete item
		target_item.queue_free()
	#delete hand
	queue_free()
	#state = HandState.RETURNING
	
	

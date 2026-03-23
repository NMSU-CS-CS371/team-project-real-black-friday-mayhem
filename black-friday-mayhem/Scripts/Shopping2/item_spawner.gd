extends Node2D #Item Spawner 
#Used to spawn multipule items for the player to get points

#Varibles
@export var spawn_interval := 1.0
@export var max_items := 20
@export var item_scene: PackedScene
@export var item_count := 8

#Function to funs when Item Spawner loads into the tree
#get everything ready to start
func _ready():
	print("ItemSpawner ready")
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start()
	spawn_item()

#spawn_item is the funciton that spawns an item 
func spawn_item():
	#checks to make sure no error
	if item_scene == null:
		#print("No item_scene assigned!")
		return
	#pick a out of 2 points
	var index = randi() % 2
	#intantiate item
	#var item = item_scene.instantiate()
	
	var screen_size= get_viewport_rect().size
	#spawn on the right side of the screen
	var spawn_x = 150
	var spawn_y = 270 #or 500
	
	for x in 50:
		var item = item_scene.instantiate()
		item.position = Vector2(spawn_x, spawn_y)
		get_parent().add_child.call_deferred(item)
		item.item_clicked.connect(_on_item_clicked)
		spawn_x += 150
		
	spawn_y = 500
	spawn_x = 150
	for x in 50:
		var item = item_scene.instantiate()
		item.position = Vector2(spawn_x, spawn_y)
		get_parent().add_child.call_deferred(item)
		item.item_clicked.connect(_on_item_clicked)
		spawn_x += 150
	#match index:
		#0:
			#spawn_y = 270
		#1:
			#spawn_y = 500
	#set spawn position
	#print("Spawned items:", item_count)

#when the player clicks on the item give points
func _on_item_clicked(points):
	get_parent().add_score(points)
	#spawn_item()
	
#when the spawn timer is over spawn an item
func _on_spawn_timer_timeout():
	if get_child_count() >= max_items:
		return
	#spawn_item()

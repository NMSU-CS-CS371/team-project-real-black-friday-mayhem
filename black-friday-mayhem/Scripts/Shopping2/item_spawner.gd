extends Node2D #Item Spawner 
#Used to spawn multipule items for the player to get points

#Varibles
@export var spawn_interval := 1.0
@export var max_items := 20
@export var item_scene: PackedScene
@export var item_count := 8
@onready var spawn_points = $"../SpawnPoints".get_children()
var free_points := []

#Function to funs when Item Spawner loads into the tree
#get everything ready to start
func _ready():
	print("ItemSpawner ready")
	free_points = spawn_points.duplicate()
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start()

#spawn_item is the funciton that spawns an item 
func spawn_item():
	#checks to make sure no error
	if free_points.size() == 0:
		#print("No free points to spawn item!")
		return
	if item_scene == null:
		#print("No item_scene assigned!")
		return
	if spawn_points == null:
		#print("SpawnPoints not found!")
		return

	#pick a random free point
	var index = randi() % free_points.size()
	var point = free_points[index]
	
	#remove from free points
	free_points.remove_at(index)

	#intantiate item
	var item = item_scene.instantiate()
	item.spawn_point = point
	item.position = point.position
	get_parent().add_child.call_deferred(item)
	item.item_clicked.connect(_on_item_clicked)
	item.tree_exited.connect(_on_item_removed.bind(item))
	#print("Spawned items:", item_count)

#when the player clicks on the item give points
func _on_item_clicked(points):
	get_parent().add_score(points)
	#spawn_item()
	
#when the spawn timer is over spawn an item
func _on_spawn_timer_timeout():
	if get_child_count() >= max_items:
		return
	spawn_item()
	
#when the item nedds to be removed this is used to to that
func _on_item_removed(item):
	if item and item.spawn_point:
		free_points.append(item.spawn_point)

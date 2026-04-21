extends Node2D
#this is the item

#on initalization it will:
#randomize its id out of 4
#choose sprite texture baised on id
#regester itself to whoever initalizes it
#adds to a group to be found
#will delete itself when clicked by mouse
@onready var player = get_tree().get_first_node_in_group("Player")

signal item_clicked(points)
#textures for the sprite
var texture_jam = preload("res://Assets/Sprites/jam.png")
var texture_corn = preload("res://Assets/Sprites/corncan.png")
var texture_toiletpaper = preload("res://Assets/Sprites/toiletPaper.png")
var texture_cereal = preload("res://Assets/Sprites/cereal.png")
#Variables
var is_taken : bool = false
var id: int
var item_price: int
var spawn_point: Node2D = null
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var shape1 : CollisionShape2D = $Area2D/CollisionShapeCap
@onready var shape2 : CollisionShape2D = $Area2D/CollisionShapeRect
@export var move_speed := 120
var parent
var end : Node2D

# Item enters scene and registers itself with game
func _ready() -> void:
	if get_parent().name == "Shopping3":
		parent = get_parent() #when the node is deleted remove from the minigame
	elif get_parent().name == "ItemSpawner":
		parent = get_parent().get_parent()
	
	print(get_parent().get_parent().get_parent().name)
	randomize()
	id = randi() % 4  # 0 to 3
	#set sprite texture to the item texture
	sprite.texture = item_texture()
	#153
	#189
	if id == 1:
		shape1.disabled = true
		shape2.disabled = false
		
		#shape.set_size(Vector2(153, 189))
		#sprite.scale = Vector2(0.6, 0.6)
	#when the node get initialized then register the node in the minigame
	#get_parent().register_item(self) 
	#when clicked got to clicked function
	add_to_group("items")

#moves the item across the screen
	# if the minigame is over, delete

	#position.x -= move_speed * delta
	# if it moves off left side of screen delete it
	#if position.x < end.global_position.x:
		#print("killed")
		#queue_free()

#choose random Item
func item_texture() -> Texture2D:
	match id:
		0: 
			item_price = 5
			sprite.offset.y = -50
			return texture_jam
		1:
			item_price = 2
			sprite.offset.y = -70
			
			return texture_cereal
			
		2:
			item_price = 3
			sprite.offset.y = -55
			return texture_corn
		3:
			item_price = 8
			sprite.offset.y = -25
			return texture_toiletpaper
	return null

#Item leaves scene and unregisters itself
func _exit_tree() -> void:
	parent.unregister_item(self) #when the node is deleted remove from the minigame

#Item can be clicked and reacts to input
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if the mouse clicks on hand delete
	if event is InputEventMouseButton and event.pressed:
		#print("Item clicked!")
		#print("Item emitting signal")
		emit_signal("item_clicked", item_price)
		purchaseItem()
		#delete Item

func purchaseItem():
	player.inventory.wallet -= item_price
	#player.inventory.moneySaved += moneySaved
	var item: InvItem
	match id:
		0:
			item = load("res://Assets/Inventory/Items/Placeholders/jam.tres")
		1:
			item = load("res://Assets/Inventory/Items/Placeholders/cereal.tres")
		2:
			item = load("res://Assets/Inventory/Items/Placeholders/corn.tres")
		3:
			item = load("res://Assets/Inventory/Items/Placeholders/toilet_paper.tres")
	player.inventory.insert(item)
	parent.update_wallet_label()
	queue_free()

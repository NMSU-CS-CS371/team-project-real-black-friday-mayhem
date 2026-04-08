extends Node2D
#this is the item

#on initalization it will:
#randomize its id out of 4
#choose sprite texture baised on id
#regester itself to whoever initalizes it
#adds to a group to be found
#will delete itself when clicked by mouse
@onready var player = get_parent().get_parent().get_parent().player

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
@export var move_speed := 120

# Item enters scene and registers itself with game
func _ready() -> void:
	randomize()
	id = randi() % 4  # 0 to 3
	#set sprite texture to the item texture
	sprite.texture = item_texture()
	#when the node get initialized then register the node in the minigame
	get_parent().register_item(self) 
	#when clicked got to clicked function
	add_to_group("items")

#moves the item across the screen
func _process(delta):
	# if the minigame is over, delete
	if not get_parent().is_running():
		queue_free()

	position.x -= move_speed * delta
	# if it moves off left side of screen delete it
	if position.x < -50:
		queue_free()

#choose random Item
func item_texture() -> Texture2D:
	match id:
		0: 
			item_price = 9
			sprite.offset.y = -50
			return texture_jam
		1:
			item_price = 6
			sprite.offset.y = -70
			return texture_cereal
			
		2:
			item_price = 7
			sprite.offset.y = -55
			return texture_corn
		3:
			item_price = 12
			sprite.offset.y = -25
			return texture_toiletpaper
	return null

#Item leaves scene and unregisters itself
func _exit_tree() -> void:
	get_parent().unregister_item(self) #when the node is deleted remove from the minigame

#Item can be clicked and reacts to input
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if the mouse clicks on hand delete
	if event is InputEventMouseButton and event.pressed:
		#print("Item clicked!")
		#print("Item emitting signal")
		emit_signal("item_clicked")
		purchaseItem()

func purchaseItem():
	player.inventory.wallet -= item_price
	# player.inventory.moneySaved += moneySaved
	var item: InvItem
	match id:
		0:
			item = load("res://Assets/Inventory/Items/jam.tres")
		1:
			item = load("res://Assets/Inventory/Items/cereal.tres")
		2:
			item = load("res://Assets/Inventory/Items/corn.tres")
		3:
			item = load("res://Assets/Inventory/Items/toilet_paper.tres")
	player.inventory.insert(item)
	get_parent().update_wallet_label()
	queue_free()

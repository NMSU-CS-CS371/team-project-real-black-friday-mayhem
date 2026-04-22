extends Node2D
#this is the item

#on initalization it will:
#randomize its id out of 4
#choose sprite texture baised on id
#regester itself to whoever initalizes it
#adds to a group to be found
#will delete itself when clicked by mouse
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var checkpoint = get_parent().get_parent()

signal item_clicked(points)

# arrays for items of different shops
var gameSlopItems = ["res://Assets/Inventory/Items/mist_dock.tres",
"res://Assets/Inventory/Items/grand_larceny.tres", "res://Assets/Inventory/Items/myth_of_esmerelda.tres"]
var hindsNobleItems = ["res://Assets/Inventory/Items/romance_novel.tres","res://Assets/Inventory/Items/manga.tres",
"res://Assets/Inventory/Items/dice.tres"]
var stacysJKNickelsItems = ["res://Assets/Inventory/Items/mom_jeans.tres","res://Assets/Inventory/Items/sun_dress.tres",
"res://Assets/Inventory/Items/polo.tres","res://Assets/Inventory/Items/khakis.tres",
"res://Assets/Inventory/Items/perfume.tres"]
var radioShackItems = ["res://Assets/Inventory/Items/radio.tres","res://Assets/Inventory/Items/phone_charger.tres",
"res://Assets/Inventory/Items/flip_phone.tres"]
var debateItems = ["res://Assets/Inventory/Items/branded_plush.tres","res://Assets/Inventory/Items/graphic_tee.tres",
"res://Assets/Inventory/Items/leg_warmers.tres"]
var itemSets = [gameSlopItems, hindsNobleItems, stacysJKNickelsItems,
radioShackItems, debateItems]

#Variables
var is_taken : bool = false
#var id: int
var item_price: int
var spawn_point: Node2D = null
var thisItem: InvItem
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var shape1 : CollisionShape2D = $Area2D/CollisionShapeCap
@onready var shape2 : CollisionShape2D = $Area2D/CollisionShapeRect
@export var move_speed := 180
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
	
	# select which shop the items are reskinning to
	var items = itemSets[checkpoint.shopName]
	
	# Pick random item
	thisItem = load(items.pick_random())
	sprite.texture = thisItem.sprite
	sprite.scale = thisItem.spriteScale * 1.3
	calculate_price()
	
	#set sprite texture to the item texture

	#153
	#189
	
		
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
func calculate_price() -> void:
	if checkpoint.shopName == checkpoint.shop.GAME_SLOP:
		item_price = randi_range(6,20)*10
	else:
		item_price = randi_range(15,30)

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
	# player.inventory.moneySaved += moneySaved
	player.inventory.insert(thisItem)
	get_parent().update_wallet_label()
	queue_free()

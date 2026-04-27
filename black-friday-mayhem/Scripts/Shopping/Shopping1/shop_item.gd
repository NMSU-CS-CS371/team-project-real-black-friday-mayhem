extends Node2D

signal item_exiting_tree

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var checkpoint = get_parent().get_parent()

var timerLength = 1
var minLength = 1
var maxLength = 5

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

var marketVal: int = 0
var discount: float = 0
var discountedPrice: int = 0
var moneySaved: int = 0
var thisItem: InvItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	var sprite2d = $Sprite2D
	var timer = $Timer
	
	# select which shop the items are reskinning to
	var items = itemSets[checkpoint.shopName]
	
	# Pick random item
	thisItem = load(items.pick_random())
	sprite2d.texture = thisItem.sprite
	sprite2d.scale = thisItem.spriteScale * 1.3
	
	# Randomly generate market value and discount, calculate price
	marketVal = randi_range(50,120)*10
	discount = randi_range(3,9)*10
	@warning_ignore("narrowing_conversion")
	discountedPrice = marketVal * ((100-discount)/100)
	moneySaved = marketVal - discountedPrice
	
	# Save these values in the InvItem
	thisItem.moneySaved = moneySaved
	thisItem.discount = discount
	
	# Shorter timer for bigger deals
	timerLength = (10 - (discount/10))*0.75
	timer.wait_time = timerLength
	timer.start()
	
	# Show price and discount on price tag
	var tag = $PriceTag
	var label: String = str(discount) + "% OFF!\n $" + str(discountedPrice)
	tag.text = label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Delete item when timer expires
func _on_timer_timeout():
	queue_free()

# On player clicking the item
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if the mouse clicks on item purchase it
	if event is InputEventMouseButton and event.pressed:
		purchase_item()

# Take money, place item in inventory
func purchase_item():
	player.inventory.wallet -= discountedPrice
	player.inventory.moneySaved += moneySaved
	# var item: InvItem
	
	#match checkpoint.shopName:
	#	checkpoint.shop.GAME_SLOP:
	#		match itemIndex:
	#			0:
	#				item = load("res://Assets/Inventory/Items/Placeholders/sample_sprite_item.tres")
	#			1:
	#				item = load("res://Assets/Inventory/Items/Placeholders/susie_item.tres")
	#			2:
	#				item = load("res://Assets/Inventory/Items/Placeholders/cat.tres")
	#		
	#		match itemIndex:
	#			0:
	#				item = load("res://Assets/Inventory/Items/mom_jeans.tres")
	#			1:
	#				item = load("res://Assets/Inventory/Items/sun_dress.tres")
	#			2:
	#				item = load("res://Assets/Inventory/Items/polo.tres")
	#			3:
	#				item = load("res://Assets/Inventory/Items/khakis.tres")
	#			4:
	#				item = load("res://Assets/Inventory/Items/perfume.tres")
	
	#match itemIndex:
	#	0:
	#		item = load("res://Assets/Inventory/Items/Placeholders/sample_sprite_item.tres")
	#	1:
	#		item = load("res://Assets/Inventory/Items/Placeholders/susie_item.tres")
	#	2:
	#		item = load("res://Assets/Inventory/Items/Placeholders/cat.tres")
	player.inventory.insert(thisItem)
	queue_free()

func _exit_tree() -> void:
	item_exiting_tree.emit()

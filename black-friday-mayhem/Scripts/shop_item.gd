extends Node2D

var timerLength = 1
var minLength = 1
var maxLength = 5
var itemNames = ["sample item", "susie", "cat"]
var sprites = ["res://Assets/Sprites/sample_sprite.png", "res://Assets/Sprites/susie.jpeg",
"res://Assets/Sprites/cat.png"]
var marketVal: int = 0
var discount: float = 0
var discountedPrice: int = 0
var moneySaved: int = 0
var itemIndex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite2d = $Sprite2D
	var rng = RandomNumberGenerator.new()
	var timer = $Timer
	
	# Pick random item
	itemIndex = randi_range(0, itemNames.size()-1)
	sprite2d.texture = load(sprites[itemIndex])
	
	# Randomly generate market value and discount, calculate price
	marketVal = rng.randi_range(50,120)*10
	discount = rng.randi_range(3,9)*10
	discountedPrice = marketVal * ((100-discount)/100)
	moneySaved = marketVal - discountedPrice
	
	# Shorter timer for bigger deals
	timerLength = (11 - (discount/10))*0.75
	timer.wait_time = timerLength
	timer.start()
	
	# Show price and discount on price tag
	var tag = $PriceTag
	var label: String = str(discount) + "% OFF!\n $" + str(discountedPrice)
	tag.text = label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Delete item when timer expires
func _on_timer_timeout():
	queue_free()

# On player clicking the item
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if $Sprite2D.get_rect().has_point(to_local(event.position)):
			print("Market Value: ", marketVal, "\nDiscount: ", discount,
			"\nPrice: ", discountedPrice, "\nMoney Saved: ", moneySaved)
			purchase_item()

# Take money, place item in inventory
func purchase_item():
	# player.money -= discountedPrice
	# player.moneySaved += moneySaved
	# player.inventory.add(itemNames[itemIndex],sprites[itemIndex], discountedPrice)
	queue_free()

extends Node2D

var timerLength = 1
var minLength = 1
var maxLength = 5
var sprites = ["res://Assets/Sprites/sample_sprite.png", "res://Assets/Sprites/susie.jpeg",
"res://Assets/Sprites/cat.png"]
var marketVal: int = 0
var discountVals = [30, 40, 50, 60, 70, 80, 90]
var discount: float = 0
var discountedPrice: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite2d = $Sprite2D
	var rng = RandomNumberGenerator.new()
	var timer = $Timer
	
	# Pick random sprite
	sprite2d.texture = load(sprites.pick_random())
	
	# Randomly generate timer length
	timerLength = rng.randf_range(minLength, maxLength)
	timer.wait_time = timerLength
	timer.start()
	
	# Randomly generate market value and discount, calculate price
	marketVal = rng.randf_range(500,1200)
	discount = discountVals.pick_random()
	discountedPrice = marketVal * ((100-discount)/100)
	
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
			print("Market Value: ", marketVal, "\nDiscount: ", discount, "\nPrice: ", discountedPrice)
			# Only prints for now, would normally call purchase_item()

# Take money, place item in inventory
func purchase_item():
	pass

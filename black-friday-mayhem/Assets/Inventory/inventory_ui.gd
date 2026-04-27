extends Control

@onready var inventory: Inventory = preload("res://Assets/Inventory/playerinventory.tres")
@onready var slots: Array = $ColorRect/GridContainer.get_children()

var is_open: bool = false

func _ready():
	inventory.update.connect(update_slots)
	update_slots()
	$ItemTag.visible = false
	close()

func update_slots():
	
	if inventory.wallet < 0:
		$WalletLabel.text = "-$"+str(abs(inventory.wallet))
		$WalletLabel.add_theme_color_override("font_color", Color(1,0,0,1))
	else:
		$WalletLabel.text = "$"+str(inventory.wallet)
		$WalletLabel.add_theme_color_override("font_color", Color(1,1,1,1))
	
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _process(_delta):
	if Input.is_action_just_pressed("e"):
		if is_open:
			close()
		else:
			open()

func show_item_tag(name: String, desc: String):
	var tagPos
	
	$ItemTag.get_child(1).text = name
	$ItemTag.get_child(2).text = desc
	# put item 
	tagPos = get_local_mouse_position()
	print(str(tagPos))
	if tagPos.x > 370.0:
		tagPos.x = 370.0
	$ItemTag.position = tagPos
	$ItemTag.visible = true

func hide_item_tag():
	$ItemTag.visible = false

func open():
	self.visible = true
	is_open = true

func close():
	self.visible = false
	is_open = false

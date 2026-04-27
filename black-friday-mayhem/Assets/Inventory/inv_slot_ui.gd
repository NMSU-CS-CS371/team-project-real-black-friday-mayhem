extends Panel

@onready var itemSprite: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var stack_text: Label = $CenterContainer/Panel/StackNum
@onready var inventoryUI = get_parent().get_parent().get_parent()

#@onready var itemTag: Panel = $ItemTag
var itemName = ""
var itemDesc = ""
var slotGlobal: InvSlot
var hovering

func _process(_delta: float):
	pass
	#var local_mouse_pos = get_local_mouse_position()
	#hovering = Rect2(Vector2(), $ColorRect.size).has_point(local_mouse_pos)
	

func update(slot: InvSlot):
	slotGlobal = slot
	
	# if slot is empty, show nothing
	if not slot.item:
		itemSprite.visible = false
		stack_text.visible = false
		#itemTag.visible = false
	else:
	# if slot has an item, show sprite
		itemSprite.visible = true
		itemSprite.texture = slot.item.sprite
		
		# adjust sprite size to fit in slot
		itemSprite.scale = slot.item.spriteScale
		
		# show number of items if there's more than one
		if slot.amount > 1:
			stack_text.visible = true
		stack_text.text = str(slot.amount)

func _on_mouse_hover():
	#print("mouse entered")
	
	# if the slot isn't null and it has an item, grab its name and description
	if slotGlobal != null and slotGlobal.item != null:
		itemName = slotGlobal.item.name
		itemDesc = slotGlobal.item.itemDesc
		
		#print(itemName)
		#print(itemDesc)
		
		# apply name and description to item tag
		inventoryUI.show_item_tag(itemName, itemDesc)
		
	
func _on_mouse_leave():
	#if hovering:
	#	return
	#print("mouse left")
	inventoryUI.hide_item_tag()
	

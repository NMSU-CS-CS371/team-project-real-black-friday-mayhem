extends Panel

@onready var itemSprite: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var stack_text: Label = $CenterContainer/Panel/StackNum
@onready var itemTag: Panel = $ItemTag
@onready var itemName = $ItemTag/ItemName
@onready var itemDesc = $ItemTag/ItemDesc
var slotGlobal: InvSlot

func _process(_delta: float):
	var local_mouse_pos := get_local_mouse_position()
	var hovering := Rect2(Vector2(), size).has_point(local_mouse_pos)
	if hovering:
		mouse_entered.emit()

func update(slot: InvSlot):
	slotGlobal = slot
	if not slot.item:
		itemSprite.visible = false
		stack_text.visible = false
		itemTag.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = slot.item.sprite
		itemSprite.scale = slot.item.spriteScale
		if slot.amount > 1:
			stack_text.visible = true
		stack_text.text = str(slot.amount)

func _on_mouse_hover():
	if slotGlobal.item:
		itemName.text = slotGlobal.item.name
		itemDesc.text = slotGlobal.item.itemDesc
		itemTag.visible = true
	
func _on_mouse_leave():
	itemTag.visible = false

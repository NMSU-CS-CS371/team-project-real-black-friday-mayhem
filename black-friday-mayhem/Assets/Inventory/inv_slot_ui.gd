extends Panel

@onready var itemSprite: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var stack_text: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	if not slot.item:
		itemSprite.visible = false
		stack_text.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = slot.item.sprite
		itemSprite.scale = slot.item.spriteScale
		if slot.amount > 1:
			stack_text.visible = true
		stack_text.text = str(slot.amount)

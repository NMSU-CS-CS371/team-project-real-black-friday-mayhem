extends Resource

class_name Inventory

signal update

@export var slots: Array[InvSlot]
@export var wallet: int = 10000
@export var moneySaved: int = 0

func insert(item: InvItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if not itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if not emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	update.emit()

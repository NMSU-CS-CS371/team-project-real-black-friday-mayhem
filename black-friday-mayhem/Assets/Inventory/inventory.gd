extends Resource

class_name Inventory

signal update

@export var slots: Array[InvSlot]
@export var wallet: int = 10000
@export var moneySaved: int = 0
@export var beatScalper: bool = false
@export var beatGrandma: bool = false
@export var beatKaren: bool = false
var numItems = 0

func insert(item: InvItem):
	
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if not itemSlots.is_empty():
		itemSlots[0].amount += 1
		numItems = numItems + 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if not emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
			numItems = numItems + 1
	update.emit()

func getItem():
	#get an item that is not a mini game item
	if (numItems == 0) :
		return null
	for slot in slots:
		if slot.item != null && slot.item.specialItem == false :
			return slot.item
	return null
		
func remove(i: InvItem):
	for slot in slots:
		if slot.item == i:
			if slot.amount <= 1:
				slot.item = null
				slot.amount = 0
			else :
				slot.amount -= 1
	
	numItems -= 1
	update.emit()

func reset():
	for i in slots.size():
		slots[i] = InvSlot.new()
	wallet = 10000
	moneySaved = 0
	beatScalper = false
	beatGrandma = false
	beatKaren = false
	update.emit()

extends Node2D

@onready var playerInventory = get_parent().get_parent().player.inventory
var bestDeal: InvItem
var mostAbundant: InvItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bestDeal = calc_best_deal()
	mostAbundant = calc_most_item()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Return the item the player got the best deal on
func calc_best_deal() -> InvItem:
	var highestDeal: int = 0
	var dealItem: InvItem
	for slot in playerInventory.slots:
		if slot.item.moneySaved > highestDeal:
			highestDeal = slot.item.moneySaved
			dealItem = slot.item
	return dealItem

# Return the item that the player got the most of 
func calc_most_item() -> InvItem:
	var highestAmount: int = 0
	var mostItem: InvItem
	for slot in playerInventory.slots:
		if slot.amount > highestAmount:
			highestAmount = slot.amount
			mostItem = slot.item
	return mostItem

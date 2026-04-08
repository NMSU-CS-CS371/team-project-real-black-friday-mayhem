extends Node2D

@onready var description = $HighlightDesc
@onready var sprite = $HighlightSprite
@onready var anim = $AnimationPlayer
var playerInventory: Inventory
var bestDeal: InvItem
var mostAbundant: InvItem
var highestAmount: int

signal finished_anim

func _ready()-> void:
	visible = false
	pass
	
func initiate(inv: Inventory):
	playerInventory = inv
	bestDeal = calc_best_deal()
	mostAbundant = calc_most_item()
	show_best_deal()
	await finished_anim
	show_most_item()

func show_best_deal():
	if bestDeal != null:
		description.text = "You got a "+str(bestDeal.discount)+"% discount and SAVED $"+str(bestDeal.moneySaved)+"!"
		sprite.texture = bestDeal.sprite
		sprite.scale = bestDeal.spriteScale
	else:
		description.text = "You didn't get ANY deals? Really? How did you manage that on Black Friday?"
		sprite.texture = load("res://Assets/Sprites/question_mark.webp")
	play_animation()

func show_most_item():
	if mostAbundant != null:
		description.text = "Your most purchased item was "+mostAbundant.name+" with a total of "+str(highestAmount)+"!"
		sprite.texture = mostAbundant.sprite
		sprite.scale = mostAbundant.spriteScale
	else:
		description.text = "Oh. So you just didn't buy anything. Weird flex, but okay."
		sprite.texture = load("res://Assets/Sprites/question_mark.webp")
	play_animation()

# Return the item the player got the best deal on
func calc_best_deal() -> InvItem:
	var highestDeal: int = 0
	var dealItem: InvItem
	for slot in playerInventory.slots:
		if slot.item != null and slot.item.moneySaved > highestDeal:
			highestDeal = slot.item.moneySaved
			dealItem = slot.item
	return dealItem

# Return the item that the player got the most of 
func calc_most_item() -> InvItem:
	highestAmount = 0
	var mostItem: InvItem
	for slot in playerInventory.slots:
		if slot.amount > highestAmount:
			highestAmount = slot.amount
			mostItem = slot.item
	return mostItem

func play_animation():
	visible = true
	anim.play("spawn_in")
	await anim.animation_finished
	anim.play("idle_spin")
	await anim.animation_finished
	anim.play("leave")
	await anim.animation_finished
	visible = false
	finished_anim.emit()

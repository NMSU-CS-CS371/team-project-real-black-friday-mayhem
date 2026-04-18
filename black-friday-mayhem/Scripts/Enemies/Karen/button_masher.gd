extends Node2D

@onready var player = get_parent().get_parent().player
@onready var invContainer = get_parent().get_parent().get_node("CenterContainer")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invContainer.visible = false
	var texture = player.inventory.getItem()
	if texture != null :
		$Item.texture = texture
	else :
		invContainer.visible = true
		queue_free()
	startgame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func startgame() :
	await get_tree().create_timer(5.0).timeout
	defeated()

func defeated():
	invContainer.visible = true
	queue_free()
	#var item: InvItem
	#item = load("res://Assets/Inventory/Items/palcomon_cards.tres")
	#player.inventory.insert(item)
	#player.inventory.beatKaren = true
	#player.controlAllowed = true

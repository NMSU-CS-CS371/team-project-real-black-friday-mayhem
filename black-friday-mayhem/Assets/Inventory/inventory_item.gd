extends Resource

class_name InvItem

@export var name: String = ""
@export var sprite: Texture2D
@export var marketVal: int
@export var discount: float
@export var realPrice: int
@export var moneySaved: int
@export var itemDesc: String = ""
@export var spriteScale: Vector2 = Vector2(1,1)

# Special items are from enemies
@export var specialItem: bool

extends Resource

class_name InvItem

@export var name: String = ""
@export var sprite: Texture2D
@export var marketVal: int
@export var discount: float
@export var realPrice: int

# Special items do not stack
@export var specialItem: bool

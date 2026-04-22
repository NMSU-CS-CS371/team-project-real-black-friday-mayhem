extends CenterContainer

@export var labels : Array[String]


func _ready() -> void:
	$RichTextLabel2.text = labels.pick_random()
	pass

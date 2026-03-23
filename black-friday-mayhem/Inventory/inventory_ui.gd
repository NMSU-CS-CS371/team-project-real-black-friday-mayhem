extends Control

var is_open: bool = false

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("e"):
		if is_open:
			close()
		else:
			open()

func open():
	self.visible = true
	is_open = true

func close():
	self.visible = false
	is_open = false

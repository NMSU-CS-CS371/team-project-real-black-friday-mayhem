extends CanvasLayer

@onready var guard = $Control/AnimatedSprite2D
@onready var panel = $Control/Panel
@onready var text_label = $Control/Panel/Label
@onready var next_button = $Control/Panel/Button

var dialogue_index := 0

var dialogue = [
	{"text": "mhm... mhm...", "frame": 0},
	{"text": "Hey hold it!", "frame": 2},
	{"text": "...", "frame": 3},
	{"text": "...exactly what I thought, another Black Friday shopper.", "frame": 2},
	{"text": "Look, you're obviously here for the mall's GOOD DEALS, so lets get this out of the way.", "frame": 1},
	{"text": "We got six shops, so have your pick of merchandise.", "frame": 1},
	{"text": "Shoppers are greedy, so grab as much as you can as fast as possible. But don't spend everything at once.", "frame": 1},
	{"text": "There's also greedier shoppers than you, so stay clear of them... or don't if you're up for a challenge.", "frame": 2},
	{"text": "When you're done with all your shopping, just leave the same way you came in.", "frame": 1},
	{"text": "Stay safe out there amigo, this isn't my first Black Friday... I've seen things...", "frame": 2},
	{"text": "...", "frame": 3}
]

func _ready():
	panel.visible = false
	next_button.pressed.connect(next_dialogue)
	show_dialogue() # remove this later if you only want it triggered by the 3D guard

func show_dialogue():
	visible = true
	panel.visible = true
	dialogue_index = 0
	update_dialogue()

func update_dialogue():
	var line = dialogue[dialogue_index]

	text_label.text = line["text"]

	guard.animation = "security"
	guard.stop()
	guard.set_frame_and_progress(line["frame"], 0.0)

func next_dialogue():
	dialogue_index += 1

	if dialogue_index >= dialogue.size():
		panel.visible = false
		visible = false
		return

	update_dialogue()

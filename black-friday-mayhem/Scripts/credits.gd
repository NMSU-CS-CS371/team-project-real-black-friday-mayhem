extends Control

@onready var credits = $CreditText

var scroll_speed = 50.0
var start_delay = 0.5
var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start below screen
	credits.position.y = get_viewport_rect().size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_delay > 0 :
		start_delay -= delta
		return
	#start scrolling after delay
	started = true
	
	if started:
		credits.position.y -= scroll_speed * delta
		
	#stop when finished
	if credits.position.y + credits.get_content_height() < 0 :
		print("Credits finished")
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

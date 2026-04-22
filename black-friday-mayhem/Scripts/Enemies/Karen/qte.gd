extends Node2D

#Varibles for QTE
signal finished(success)
@export var keyString: String 
@export var keyCode: Key 
@export var eventDurtion = 1.5
@export var displayDuration = 1.5
@onready var color_rect = $ColorRect
@onready var key_label = $ColorRect/KeyLabel
@onready var success_label = $SuccessLabel
var tween
var success = false
var spawn_index: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#code for QTE in ready
	add_to_group("QTE")
	key_label.text = keyString
	_animation()  # don't await
	
	await get_tree().create_timer(eventDurtion).timeout
	
	if not success:
		finished.emit(false) # failure
		success = false
		hide()

func _animation() :
	tween = create_tween()
	tween.tween_property(color_rect, "material:shader_parameter/value", 0, eventDurtion)
	await tween.finished
	
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(keyCode) and not success_label.visible:
		success_label.show()
		color_rect.hide()
		if tween and tween.is_running():
			tween.kill()
		finished.emit(true)  # success
		success = true
		await get_tree().create_timer(displayDuration).timeout
		hide()

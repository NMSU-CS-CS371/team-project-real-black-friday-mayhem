extends Node2D

#variables for the UI
signal textbox_closed
var can_close_textbox = false
var cant_hit_buttons = true
var attacking = false
signal game_finished(result) # result could be "win" or "lose"
@onready var transition = $Transition
#variables for gameplay
var player_health = 35
var enemy_health = 35
var max_health = 35
var damage = 20
var attackTexture = preload("res://Assets/Textures/ScalperAttack.png")
var idleTexture = preload("res://Assets/Textures/ScalperIdle.png")
var hurtTexture = preload("res://Assets/Textures/ScalperHurt.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health($EnemyContatainer/EnemyHealth, enemy_health, max_health)
	set_health($PlayerContatainer/PlayerHealth, player_health, max_health)
	$Background.hide()
	$EnemyContatainer.hide()
	$PlayerContatainer.hide()
	$TextBox.hide()
	$ButtonPanel.hide()
	transition.show()
	transition.play("intoTransition")
	await get_tree().create_timer(1).timeout
	transition.hide()
	$Background.show()
	$EnemyContatainer/Enemy.texture = idleTexture
	$EnemyContatainer.show()
	$PlayerContatainer.show()
	$TextBox.show()
	transition.show()
	transition.play("outTransition")
	await get_tree().create_timer(1).timeout
	transition.hide()
	display_text("An Enemy Has Appeared!!!")
	await textbox_closed
	$ButtonPanel.show()	

#UI Functions
#used for displaying text to the UI
func display_text(text) :
	$TextBox.show()
	$TextBox/Panel/Label.text = text
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	
	can_close_textbox = false
	cant_hit_buttons = true
	await get_tree().create_timer(0.1).timeout
	can_close_textbox = true
	
#used for when the UI is interacted with
func _input(_event: InputEvent) -> void:
	if can_close_textbox and $TextBox.visible and (
		Input.is_action_just_pressed("ui_accept") or 
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		cant_hit_buttons = true
		$TextBox.hide()
		emit_signal("textbox_closed")
		if !attacking :
			$ButtonPanel/MarginContainer/HBoxContainer.show()
			cant_hit_buttons = false

#used to close the mini game when player hits the run button
func _on_run_pressed() -> void:
	if cant_hit_buttons :
		return
	display_text("Leaving Fight!!!")
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	emit_signal("game_finished", "run")
	queue_free()

#Game Play Functions
#used to set the health
func set_health(progress_bar, health, max_hp):
	#takes in the progress bar, the health and the max health
	progress_bar.value = health
	progress_bar.max_value = max_hp
	progress_bar.get_node("Health").text = "HP: %d/%d" % [health, max_hp]

func _on_attack_pressed() -> void:
	if cant_hit_buttons :
		return
	cant_hit_buttons = true
	attacking = true
	display_text("You Attack!")
	await textbox_closed
	enemy_health = max(0, enemy_health-damage)
	set_health($EnemyContatainer/EnemyHealth, enemy_health, max_health)
	$EnemyContatainer/Enemy.texture = hurtTexture
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	$EnemyContatainer/Enemy.texture = idleTexture
	display_text("You dealt %d damage" % [damage])
	await textbox_closed
	enemy_turn()
	
func enemy_turn() :
	if enemy_health <= 0 :
		enemy_defeated()
		return
	display_text("Enemy Attacks YOU")
	await textbox_closed
	player_health = max(0, player_health-damage)
	set_health($PlayerContatainer/PlayerHealth, player_health, max_health)
	$EnemyContatainer/Enemy.texture = attackTexture
	$AnimationPlayer.play("player_damaged")
	await $AnimationPlayer.animation_finished
	$EnemyContatainer/Enemy.texture = idleTexture
	display_text("Enemy dealt %d damage" % [damage])
	await textbox_closed
	attacking = false
	cant_hit_buttons = false
	
func enemy_defeated() :
	$EnemyContatainer/Enemy.texture = hurtTexture
	display_text("Enemy Defeated You Win!!!")
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	# Emit the win signal 
	emit_signal("game_finished", "win")
	queue_free()

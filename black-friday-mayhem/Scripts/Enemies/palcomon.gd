extends Node2D
#JUST NEEDS AUDIO

@onready var player = get_parent().get_parent().player
@onready var invContainer = get_parent().get_parent().get_node("CenterContainer")

#variables for the UI
signal textbox_closed
var can_close_textbox = false
var cant_hit_buttons = true
var attacking = false
signal game_finished(result) # result could be "win" or "lose"
signal pal_chosen
@onready var transition = $Transition
#variables for gameplay
var player_health = 80
var enemy_health = 100
var enemy_max = 100
var player_max = 80
var enemy_attack_count = 0
var is_Defending = false
var attackTexture = preload("res://Assets/Textures/ScalperAttack.png")
var idleTexture = preload("res://Assets/Textures/ScalperIdle.png")
var hurtTexture = preload("res://Assets/Textures/ScalperHurt.png")
var crowbarTexture = preload("res://Assets/Textures/RustyCrowbar.png")
var cartTexture = preload("res://Assets/Textures/Cart.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invContainer.visible = false
	set_health($EnemyContatainer/EnemyHealth, enemy_health, enemy_max)
	set_health($PlayerContatainer/PlayerHealth, player_health, player_max)
	$Background.hide()
	$EnemyContatainer.hide()
	$PlayerContatainer.hide()
	$PlayerContatainer.rotation = 0
	$TextBox.hide()
	$ButtonPanel.hide()
	$PalButtons.hide()
	$AttackButtons.hide()
	start_game()
	

func start_game() :
	#transition animation
	transition.show()
	transition.play("intoTransition")
	await get_tree().create_timer(1).timeout
	transition.hide()
	$Background.show()
	
	#start enemy animation
	$EnemyContatainer/Enemy.texture = idleTexture
	transition.show()
	transition.play("outTransition")
	await get_tree().create_timer(1).timeout
	transition.hide()
	$AnimationPlayer.play("enemyStart")
	$EnemyContatainer.show()
	await $AnimationPlayer.animation_finished
	
	#start text
	display_text("You Encounter a Palcomon Scalper!!!")
	await textbox_closed
	display_text("Choose a Palcomon to fight with!")
	await textbox_closed
	
	#choose pal to fight with
	$PalButtons.show()
	await pal_chosen
	
	#show button panel
	$ButtonPanel.show()	
#
#UI Functions
#
#used for displaying text to the UI
func display_text(text) :
	$TextBox.show()
	$TextBox/Panel/Label.text = text
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	can_close_textbox = false
	cant_hit_buttons = true
	await get_tree().create_timer(0.1).timeout
	can_close_textbox = true
#
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
#
#Game Play Functions
#
#used to set the health
func set_health(progress_bar, health, max_hp):
	#takes in the progress bar, the health and the max health
	progress_bar.value = health
	progress_bar.max_value = max_hp
	progress_bar.get_node("Health").text = "HP: %d/%d" % [health, max_hp]
#
func attack(text, damage, type) :
	display_text(text)
	await textbox_closed
	enemy_health = max(0, enemy_health-damage)
	set_health($EnemyContatainer/EnemyHealth, enemy_health, enemy_max)
	$EnemyContatainer/Enemy.texture = hurtTexture
	$PlayerContatainer/PlayerHealth.hide()
	match type :
		"swing":
			$AnimationPlayer.play("player_attack")
		"bash":
			$AnimationPlayer.play("player_bash")
		"insult":
			$AnimationPlayer.play("player_insult")
	await $AnimationPlayer.animation_finished
	$PlayerContatainer/PlayerHealth.show()
	$EnemyContatainer/Enemy.texture = idleTexture
	display_text("You dealt %d damage" % [damage])
	await textbox_closed
	enemy_turn()
#
func enemy_turn() :
	if enemy_health <= 0 :
		enemy_defeated()
		return
	match enemy_attack_count:
		0 : # normal attack
			enemy_attack("Scalper SCRACHES you", 15)
			enemy_attack_count += 1
		1 : # insult attack
			enemy_attack("Scalper INSULTS you", 25)
			enemy_attack_count += 1
		2: # crazy attack
			enemy_attack("Scalper LUNGES at you", 40)
			enemy_attack_count = 0
#
func enemy_attack(text, damage) :
	display_text(text)
	await textbox_closed
	if is_Defending :
		$EnemyContatainer/Enemy.texture = attackTexture
		$AnimationPlayer.play("player_damaged")
		await $AnimationPlayer.animation_finished
		$EnemyContatainer/Enemy.texture = idleTexture
		display_text("you succsefully DEFENDED!")
		await textbox_closed
		is_Defending = false
	else :
		player_health = max(0, player_health-damage)
		set_health($PlayerContatainer/PlayerHealth, player_health, player_max)
		$EnemyContatainer/Enemy.texture = attackTexture
		$AnimationPlayer.play("player_damaged")
		await $AnimationPlayer.animation_finished
		$EnemyContatainer/Enemy.texture = idleTexture
		display_text("Enemy dealt %d damage" % [damage])
		await textbox_closed
	if player_health <= 0 :
		player_defeated()
	attacking = false
	cant_hit_buttons = false
#
func enemy_defeated() :
	$EnemyContatainer/Enemy.texture = hurtTexture
	display_text("You have defeated the Scalper!!!")
	await textbox_closed
	display_text("The Scalper dropped a pack of palcomon cards!")
	var item: InvItem
	item = load("res://Assets/Inventory/Items/palcomon_cards.tres")
	player.inventory.insert(item)
	player.controlAllowed = true
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	# Emit the win signal 
	emit_signal("game_finished", "win")
	invContainer.visible = true
	queue_free()
#
func player_defeated() :
	display_text("You have been Defeated!!!")
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	emit_signal("game_finished", "lose")
	invContainer.visible = true
	queue_free()
#
#singals from node children
#
#used to close the mini game when player hits the run button
func _on_run_pressed() -> void:
	if cant_hit_buttons :
		return
	display_text("Leaving Fight!!!")
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	emit_signal("game_finished", "run")
	invContainer.visible = true
	queue_free()
	
func _on_attack_pressed() -> void:
	if cant_hit_buttons :
		return
	cant_hit_buttons = true
	attacking = true
	if $PlayerContatainer/Player.texture == crowbarTexture :
		$AttackButtons/MarginContainer/HBoxContainer/Normal.text = "SWING"
		$AttackButtons/MarginContainer/HBoxContainer/Insult.text = "INSULT"
	else :
		$AttackButtons/MarginContainer/HBoxContainer/Normal.text = "BASH"
		$AttackButtons/MarginContainer/HBoxContainer/Insult.text = "INSULT"
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	$AttackButtons.show()
	
func _on_crowbar_pressed() -> void:
	$PlayerContatainer/Player.texture = crowbarTexture
	set_health($PlayerContatainer/PlayerHealth, player_health, player_max)
	$AnimationPlayer.play("playerStart")
	$PlayerContatainer.show()
	$PalButtons.hide()
	await $AnimationPlayer.animation_finished
	$PalButtons.hide()
	emit_signal("pal_chosen")

func _on_cart_pressed() -> void:
	$PlayerContatainer/Player.texture = cartTexture
	set_health($PlayerContatainer/PlayerHealth, player_health-20, player_max-20)
	$AnimationPlayer.play("playerStart")
	$PlayerContatainer.show()
	$PalButtons.hide()
	await $AnimationPlayer.animation_finished
	$PalButtons.hide()
	emit_signal("pal_chosen")
#
func _on_normal_pressed() -> void:
	$AttackButtons.hide()
	if $PlayerContatainer/Player.texture == crowbarTexture :
		attack("You SWING at the Scalper!", 25, "swing")
	if $PlayerContatainer/Player.texture == cartTexture :
		attack("You BASH you cart into the Scalper!", 35, "bash")
#
func _on_insult_pressed() -> void:
	$AttackButtons.hide()
	if $PlayerContatainer/Player.texture == crowbarTexture :
		attack("You try to INSULT the Scalper!", 5,"insult")
	if $PlayerContatainer/Player.texture == cartTexture :
		attack("You INSULT the Scalper!", 40,"insult")


func _on_defend_pressed() -> void:
	display_text("You get ready to DEFEND!")
	await textbox_closed
	is_Defending = true
	enemy_turn()

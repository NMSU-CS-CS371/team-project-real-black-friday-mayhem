extends Node2D #Palcomon Mini Game

#variables for changing inventory status
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
var defending_count = 0
var is_Defending = false
var attackTexture = preload("res://Assets/Textures/ScalperAttack.png")
var idleTexture = preload("res://Assets/Textures/ScalperIdle.png")
var hurtTexture = preload("res://Assets/Textures/ScalperHurt.png")
var crowbarTexture = preload("res://Assets/Textures/RustyCrowbar.png")
var cartTexture = preload("res://Assets/Textures/Cart.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invContainer.visible = false
	#set main health
	set_health($EnemyContatainer/Enemy/EnemyHealth, enemy_health, enemy_max)
	set_health($PlayerContatainer/PlayerHealth, player_health, player_max)
	#hiding all assets
	$Background.hide()
	$EnemyContatainer.hide()
	$PlayerContatainer.hide()
	$PlayerContatainer.rotation = 0
	$TextBox.hide()
	$ButtonPanel.hide()
	$PalButtons.hide()
	$AttackButtons.hide()
	#start game
	start_game()

#start game with transition and base decisions
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
	await get_tree().create_timer(2.2).timeout
	transition.hide()
	$AnimationPlayer.play("enemyStart")
	$EnemyContatainer.show()
	await $TransitionMusic.finished
	$Music.play()
	await $AnimationPlayer.animation_finished
	#start text
	display_text("You Encounter a Palcomon Scalper!!!")
	$VoiceLines/Start.play()
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

#used for when the UI is interacted with
func _input(_event: InputEvent) -> void:
	if can_close_textbox and $TextBox.visible and (
		Input.is_action_just_pressed("ui_accept") or 
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		cant_hit_buttons = true
		$SoundEffects/textbox.play()
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

#used to attack
func attack(text, damage, type) :
	display_text(text)
	await textbox_closed
	if $VoiceLines/PickCart.is_playing or $VoiceLines/PickCrow.is_playing :
		$VoiceLines/PickCart.stop()
		$VoiceLines/PickCrow.stop()
	enemy_health = max(0, enemy_health-damage)
	set_health($EnemyContatainer/Enemy/EnemyHealth, enemy_health, enemy_max)
	$EnemyContatainer/Enemy.texture = hurtTexture
	$PlayerContatainer/PlayerHealth.hide()
	match type :
		"swing":
			$AnimationPlayer.play("player_attack")
			$SoundEffects/crowHit.play()
			if $VoiceLines/GO.is_playing or $VoiceLines/Insults.is_playing :
				$VoiceLines/GO.stop()
				$VoiceLines/Insults.stop()
			$VoiceLines/Attack.play()
		"bash":
			$AnimationPlayer.play("player_bash")
			$SoundEffects/cartHit.play()
			if $VoiceLines/GO.is_playing or $VoiceLines/Insults.is_playing :
				$VoiceLines/GO.stop()
				$VoiceLines/Insults.stop()
			$VoiceLines/Attack.play()
		"insult":
			$AnimationPlayer.play("player_insult")
			if $PlayerContatainer/Player.texture == cartTexture :
				if $VoiceLines/GO.is_playing or $VoiceLines/Insults.is_playing :
					$VoiceLines/GO.stop()
					$VoiceLines/Insults.stop()
				$VoiceLines/CartInsult.play()
			else :
				if $VoiceLines/GO.is_playing or $VoiceLines/Insults.is_playing :
					$VoiceLines/GO.stop()
					$VoiceLines/Insults.stop()
				$VoiceLines/CrowInsult.play()
	await $AnimationPlayer.animation_finished
	$PlayerContatainer/PlayerHealth.show()
	$EnemyContatainer/Enemy.texture = idleTexture
	display_text("You dealt %d damage" % [damage])
	await textbox_closed
	enemy_turn()
	
#used when its the enemies turn
func enemy_turn() :
	if enemy_health <= 0 :
		enemy_defeated()
		return
	match enemy_attack_count:
		0 : # normal attack
			enemy_attack("Scalper SCRATCHES you", 15)
			enemy_attack_count += 1
		1 : # insult attack
			enemy_attack("Scalper INSULTS you", 25)
			enemy_attack_count += 1
		2: # crazy attack
			enemy_attack("Scalper LUNGES at you", 40)
			enemy_attack_count = 0

#function for when the enemy attacks player
func enemy_attack(text, damage) :
	display_text(text)
	await textbox_closed
	if is_Defending :
		defending_count += 1
		if $VoiceLines/PickCart.is_playing or $VoiceLines/PickCrow.is_playing :
			$VoiceLines/PickCart.stop()
			$VoiceLines/PickCrow.stop()
		$EnemyContatainer/Enemy.texture = attackTexture
		$AnimationPlayer.play("player_damaged")
		if $VoiceLines/Attack.is_playing or $VoiceLines/CrowInsult.is_playing or $VoiceLines/CartInsult :
			$VoiceLines/Attack.stop()
			$VoiceLines/CrowInsult.stop()
			$VoiceLines/CartInsult.stop()
		#if else loop for defending voice lines
		if defending_count <= 1 :
			$VoiceLines/Defend.play()
		elif defending_count <= 2 :
			$VoiceLines/Defend2.play()
		elif defending_count <= 3 :
			$VoiceLines/Defend3.play()
		elif defending_count <= 4 :
			$VoiceLines/Defend4.play()
		elif defending_count <= 5 :
			$VoiceLines/Defend5.play()
		else :
			$VoiceLines/Defend6.play()
			defending_count = 0
		await $AnimationPlayer.animation_finished
		$EnemyContatainer/Enemy.texture = idleTexture
		display_text("you succsefully DEFENDED!")
		await textbox_closed
		$ButtonPanel.show()
		is_Defending = false
	else :
		player_health = max(0, player_health-damage)
		set_health($PlayerContatainer/PlayerHealth, player_health, player_max)
		$EnemyContatainer/Enemy.texture = attackTexture
		$AnimationPlayer.play("player_damaged")
		if enemy_attack_count == 2 :
			if $VoiceLines/Attack.is_playing or $VoiceLines/CrowInsult.is_playing or $VoiceLines/CartInsult :
				$VoiceLines/Attack.stop()
				$VoiceLines/CrowInsult.stop()
				$VoiceLines/CartInsult.stop()
			$VoiceLines/Insults.play()
		else :
			if $VoiceLines/Attack.is_playing or $VoiceLines/CrowInsult.is_playing or $VoiceLines/CartInsult :
				$VoiceLines/Attack.stop()
				$VoiceLines/CrowInsult.stop()
				$VoiceLines/CartInsult.stop()
			$VoiceLines/GO.play()
		await $AnimationPlayer.animation_finished
		$EnemyContatainer/Enemy.texture = idleTexture
		display_text("Enemy dealt %d damage" % [damage])
		await textbox_closed
	if player_health <= 0 :
		player_defeated()
	attacking = false
	cant_hit_buttons = false

#when the enemy is defeated
func enemy_defeated() :
	$EnemyContatainer/Enemy.texture = hurtTexture
	display_text("You have defeated the Scalper!!!")
	if $VoiceLines/Attack.is_playing or $VoiceLines/CrowInsult.is_playing or $VoiceLines/CartInsult :
		$VoiceLines/Attack.stop()
		$VoiceLines/CrowInsult.stop()
		$VoiceLines/CartInsult.stop()
	$VoiceLines/Win.play()
	await textbox_closed
	display_text("The Scalper dropped a pack of palcomon cards!")
	var item: InvItem
	item = load("res://Assets/Inventory/Items/palcomon_cards.tres")
	player.inventory.insert(item)
	player.inventory.beatScalper = true
	player.controlAllowed = true
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	# Emit the win signal 
	emit_signal("game_finished", "win")
	invContainer.visible = true
	queue_free()

#when the player loses 
func player_defeated() :
	display_text("You have been Defeated!!!")
	if $VoiceLines/GO.is_playing or $VoiceLines/Insults.is_playing :
		$VoiceLines/GO.stop()
		$VoiceLines/Insults.stop()
	$VoiceLines/Lose.play()
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	emit_signal("game_finished", "lose")
	invContainer.visible = true
	player.controlAllowed = true
	queue_free()
#
#singals from node children
#
#used to close the mini game when player hits the run button
func _on_run_pressed() -> void:
	if cant_hit_buttons :
		return
	$SoundEffects/button.play()
	if $VoiceLines/PickCart.is_playing or $VoiceLines/PickCrow.is_playing :
		$VoiceLines/PickCart.stop()
		$VoiceLines/PickCrow.stop()
	$VoiceLines/Run.play()
	display_text("Leaving Fight!!!")
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	await textbox_closed
	await get_tree().create_timer(0.25).timeout
	emit_signal("game_finished", "run")
	invContainer.visible = true
	player.controlAllowed = true
	queue_free()
	
#when the attack button is pressed
func _on_attack_pressed() -> void:
	if cant_hit_buttons :
		return
	$SoundEffects/button.play()
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
	
#when crowbar is pressed 
func _on_crowbar_pressed() -> void:
	$SoundEffects/button.play()
	$PlayerContatainer/Player.texture = crowbarTexture
	set_health($PlayerContatainer/PlayerHealth, player_health, player_max)
	$AnimationPlayer.play("playerStart")
	if $VoiceLines/Start.is_playing :
		$VoiceLines/Start.stop()
	$VoiceLines/PickCrow.play()
	$PlayerContatainer.show()
	$PalButtons.hide()
	await $AnimationPlayer.animation_finished
	$PalButtons.hide()
	emit_signal("pal_chosen")

#when the cart button is pressed
func _on_cart_pressed() -> void:
	$SoundEffects/button.play()
	$PlayerContatainer/Player.texture = cartTexture
	set_health($PlayerContatainer/PlayerHealth, player_health-20, player_max-20)
	$AnimationPlayer.play("playerStart")
	if $VoiceLines/Start.is_playing :
		$VoiceLines/Start.stop()
	$VoiceLines/PickCart.play()
	$PlayerContatainer.show()
	$PalButtons.hide()
	await $AnimationPlayer.animation_finished
	$PalButtons.hide()
	emit_signal("pal_chosen")

#when a normal attack button is pressed 
func _on_normal_pressed() -> void:
	$SoundEffects/button.play()
	$AttackButtons.hide()
	if $PlayerContatainer/Player.texture == crowbarTexture :
		attack("You SWING at the Scalper!", 25, "swing")
	if $PlayerContatainer/Player.texture == cartTexture :
		attack("You BASH you cart into the Scalper!", 25, "bash")
		

#when insult button is pressed
func _on_insult_pressed() -> void:
	$SoundEffects/button.play()
	$AttackButtons.hide()
	if $PlayerContatainer/Player.texture == crowbarTexture :
		attack("You try to INSULT the Scalper!", 10,"insult")
	if $PlayerContatainer/Player.texture == cartTexture :
		$SoundEffects/cartInsult.play()
		attack("You INSULT the Scalper!", 30,"insult")

#when defend button is pressed 
func _on_defend_pressed() -> void:
	if cant_hit_buttons :
		return
	$SoundEffects/button.play()
	cant_hit_buttons = true
	$ButtonPanel.hide()
	display_text("You get ready to DEFEND!")
	await textbox_closed
	is_Defending = true
	$ButtonPanel/MarginContainer/HBoxContainer.hide()
	enemy_turn()

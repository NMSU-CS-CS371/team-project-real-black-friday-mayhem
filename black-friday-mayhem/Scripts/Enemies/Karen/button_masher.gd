extends Node2D

@onready var player = get_parent().get_parent().player
@onready var invContainer = get_parent().get_parent().get_node("CenterContainer")
signal game_finished(result)
var texture
var scene1 = preload("res://Assets/Textures/KarenStop.png")
var scene2 = preload("res://Assets/Textures/KarenStealing.png")


#varibles for QTE
@onready var timer : Timer = $Timer
const QTE = preload("res://Scenes/Enemies/Karen/qte.tscn")
var keyList = [
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "A", "keyCode": KEY_A},
	{"keyString": "J", "keyCode": KEY_J},
	{"keyString": "R", "keyCode": KEY_R},
	{"keyString": "L", "keyCode": KEY_L},
	{"keyString": "V", "keyCode": KEY_V},
	{"keyString": "S", "keyCode": KEY_S},
	{"keyString": "M", "keyCode": KEY_M},
	{"keyString": "W", "keyCode": KEY_W}
]
var count = 0
var keyPressedList = []
var spawn_positions = [
	Vector2(500, 80),
	Vector2(80, 150)
]
var whatKid = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invContainer.visible = false
	$Background.hide()
	$scene.hide()
	$Karen.hide()
	$Item.hide()
	$hands.hide()
	$ProgressBar.hide()
	$ProgressBar.max_value = 400
	$ProgressBar.value = 150
	$Baby.hide()
	$BabyKick.hide()
	$Kid.hide()
	$KidKick.hide()
	texture = player.inventory.getItem()
	if texture != null :
		$Item.texture = texture.sprite
	else :
		invContainer.visible = true
		player.controlAllowed = true
		emit_signal("game_finished", "win")
		queue_free()
		return
		
	#before I start the game I need a transition sceen with story 
	#and instructions on how to play game
	$Background.show()
	$scene.texture = scene1
	$scene.show()
	await get_tree().create_timer(1.0).timeout
	$scene.texture = scene2
	await get_tree().create_timer(1.0).timeout
	$scene.hide()
	startgame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not $ProgressBar.visible:
		return
	
	#need to add an if statement that if the item gets to a certain point the game ends
	if $ProgressBar.value <= 0:
		defeated()
	elif $ProgressBar.value >= 400:
		lose()
	else :
		$ProgressBar.value += 0.4 
		if not $AnimationPlayer.is_playing() :
			$AnimationPlayer.play("Shake")

	

func startgame() :
	#set bool to true that the game has started letting the procces func know it can start going
	$Background.show()
	$Karen.show()
	$Item.show()
	$hands.show()
	$ProgressBar.show()
	$AnimationPlayer.play("Shake")
	timer.start()
	
func lose():
	invContainer.visible = true
	player.controlAllowed = true
	emit_signal("game_finished", "lose")
	player.inventory.remove(texture)
	queue_free()
	
func defeated():
	var item: InvItem
	item = load("res://Assets/Inventory/Items/karen_glasses.tres")
	player.inventory.insert(item)
	player.inventory.beatKaren = true
	player.controlAllowed = true
	invContainer.visible = true
	emit_signal("game_finished", "win")
	queue_free()
	
#used for when the spacebar is interacted with
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") :
		$ProgressBar.value += -7


func _on_timer_timeout() -> void:
	if count >= keyList.size() :
		count = 0
	
	var qte = QTE.instantiate()
	# set position
	qte.global_position = spawn_positions.pick_random()
	if qte.global_position == spawn_positions[0] :
		whatKid = 1
	else :
		whatKid = 2
	# set key
	qte.keyCode = keyList[count].keyCode
	qte.keyString = keyList[count].keyString
	# connect BEFORE adding
	qte.finished.connect(_on_key_finished)
	add_child(qte)
	count += 1
	
func  _on_key_finished(success) :
	keyPressedList.append(success)
	if success :
		if whatKid == 1 :
			showKids($KidKick, "kicked")
		elif whatKid == 2 :
			showKids($BabyKick, "kicked")
	else :
		$ProgressBar.value += +50
		if whatKid == 1 :
			showKids($Kid, "Attacked")
		elif whatKid == 2 :
			showKids($Baby, "Attacked")
		
		
func showKids(child, a) :
	child.show()
	$AnimationPlayer.play(a)
	await $AnimationPlayer.animation_finished
	child.hide()
	
	
	

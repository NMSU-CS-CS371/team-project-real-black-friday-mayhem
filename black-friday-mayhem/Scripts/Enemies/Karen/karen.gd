extends Node3D

#movement varibles
@export var speed := 1.0
@export var pause_time := 1.5
@export var move_time := 5.0
var moving = true
var time = 0.0
var radius = 5.0
#var speed = 1.0
var angle = 0.0
var center : Vector3
var last_position = Vector3.ZERO
@onready var sprite = $AnimatedSprite3D
var game = preload("res://Scenes/Enemies/Karen/button_masher.tscn")

#mini game varibles
var is_defeated = false
var playing_game = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_position = global_position
	center = global_position  # starting point = center of circle
	cycle()

func _physics_process(_delta: float) -> void:
	if $RayCast3D.is_colliding():
		var floor_height = $RayCast3D.get_collision_point().y
		global_position.y = floor_height

func cycle():
	while true:
		# Move phase
		moving = true
		await get_tree().create_timer(move_time).timeout
		# Pause phase
		moving = false
		sprite.play("idle")
		await get_tree().create_timer(pause_time).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_defeated :
		#$AnimatedSprite3D.play("defeated")
		sprite.offset.y = 7
	elif playing_game :
		sprite.play("idle")
	else :
		sprite.offset.y = 15
		if moving:
			#-move-
			#time += delta * speed
			angle += speed * delta
			
			#calculate new position
			var new_x = center.x + cos(angle) * radius
			var new_z = center.z + sin(angle) * radius
			global_position = Vector3(new_x, global_position.y, new_z)
			update_animation()
			last_position = global_position
	
func update_animation() :
	var direction = global_position - last_position
	
	#prevents tiny jittering movements
	if direction.length() < 0.001 :
		return
		
	#normalize the direction
	direction = direction.normalized()
	
	#decide animation
	if abs(direction.x) > abs(direction.z) :
		if direction.x > 0 :
			play_if_not("Right")
		else :
			play_if_not("Left")
	else :
		if direction.z > 0 :
			play_if_not("Forward")
		else :
			play_if_not("Back")


func play_if_not(anim):
	if sprite.animation != anim:
		sprite.play(anim)

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.inventory.numItems <= 0 :
		return
	if playing_game :
		return
	print("karen hit")
	body.stop_velocity.emit()
	
	playing_game = true
	var battle = game.instantiate()
	add_child(battle)
	battle.connect("game_finished", Callable(self, "_on_minigame_finished"))

func _on_minigame_finished(result):
	if result == "win" :
		is_defeated = false
		#print("Enemy defeated")
	playing_game = false

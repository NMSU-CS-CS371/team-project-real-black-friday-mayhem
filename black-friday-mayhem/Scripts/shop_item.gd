extends Sprite2D

var timerLength = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timerLength = RandomNumberGenerator.randf_range(3,10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Timerpass :
		
	

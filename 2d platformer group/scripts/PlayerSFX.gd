extends AudioStreamPlayer2D

@onready var player = get_tree().get_root().get_node("World").get_node("player")
var isInAir

func _ready():
	if player.is_on_floor():
		isInAir = true
	else:
		isInAir = true

func _physics_process(delta):
	if player.is_on_floor() != isInAir:
		var iof = player.is_on_floor()
		if !iof:
			play()
		else:
			$Land.play()
			pass
		isInAir = !isInAir

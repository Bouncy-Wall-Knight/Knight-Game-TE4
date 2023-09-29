extends Node

var player

func _ready():
	player = %player
	if player != null:
		print(player.position)
#		player.positon.x = -35
#		player.positon.x = 10

func _process(_delta):
	if player != null:
		if player.position.y > 200:
			player.set_position(Vector2(-35, -40))

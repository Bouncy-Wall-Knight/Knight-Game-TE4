extends Node

var player : CharacterBody2D

func _ready():
	player = get_node("root/World/player")
	pass




func _on_check_button_toggled(button_pressed):
	print("nest 0")
	if $Panel/CheckButton.toggled:
		print("nest 1")
		if player != null:
			print("nest 2")
			while $Panel/CheckButton.toggled:
				player.set_position(Vector2(-35, -40))

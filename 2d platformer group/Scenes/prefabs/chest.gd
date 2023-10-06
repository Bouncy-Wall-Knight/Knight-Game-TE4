extends StaticBody2D
class_name Chest

@onready var label = $Panel/Label
@onready var panel = $Panel
@onready var chest = $CollisionShape2D
@onready var button = $Panel/ButtonPanel
const FILE_PATH := "user://main.ksave"
@export var text = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	
#	var speaces = text.count("//")
	label.text = text.replace("//","\n")
	print(label.size.y)
	panel.size.y = 50 if label.size.y < panel.size.y - 10  else label.size.y + 10
	panel.position.y -= panel.size.y - 50
	button.position.y = panel.position.y + panel.size.y + 20
#	panel.size.x = 60 if label.size.x < 50 else label.size.x + 22
#	label.size.x = panel.size.x
#	panel.position.x = tileamap.position.x - panel.size.x/2
#	button.size.x = panel.size.x-10
#	button.position.x = 5
	panel.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.name == "player":
		panel.visible = true



func _on_area_2d_body_exited(body):
	if body.name == "player":
		panel.visible = false


func _on_button_button_down():
	DirAccess.remove_absolute(FILE_PATH)
	get_tree().change_scene_to_file("res://Scenes/prefabs/emil.tscn")

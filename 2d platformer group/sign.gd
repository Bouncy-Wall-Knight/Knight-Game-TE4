extends StaticBody2D
class_name Sign

@onready var label = $Panel/Label
@onready var panel = $Panel
@export var text = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text.replace("//"," ")
	print(label.size.y)
	panel.size.y = 50 if label.size.y < panel.size.y - 10  else label.size.y + 10
	panel.position.y -= panel.size.y - 50
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

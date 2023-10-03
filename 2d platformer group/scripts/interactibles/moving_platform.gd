@tool
extends Node2D

const IDLE_DURATION = 0.5

@export var move_to = Vector2.RIGHT:
	get:
		return move_to
	set(value):
		if value != move_to:
			queue_redraw()
			if tween != null:
				tween.stop()
				tween.kill()
				_init_tween()
		move_to = value
			#draw_line(Vector2.ZERO, move_to, Color.GOLD, 1, false)
			#property_list_changed_notify()
@export var speed = 50.0

@onready var platform = $Platform
@onready var ray = $Ray

var tween: Tween

func _draw():
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, move_to, Color.GOLD, 1, false)

func _ready():
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed * Globals.UNIT_SIZE)
	if !Engine.is_editor_hint() && tween != null:
		tween.kill()
	tween = create_tween()
	
	tween.set_loops(0)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(platform, "position", move_to, duration).set_delay(IDLE_DURATION)
	tween.tween_property(platform, "position", Vector2.ZERO, duration).set_delay(IDLE_DURATION)
	tween.play()


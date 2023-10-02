extends CharacterBody2D

@export var speed = 200
var dir = 1

func _physics_process(delta):
	var is_player = false
	var collided = false
	if is_on_wall():
		collided = true
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().name == "player":
				is_player = true
	if !is_player && collided:
		dir = -dir
	if dir == 1:
		set_position(Vector2(position.x + (delta * speed), position.y))
	else:
		set_position(Vector2(position.x + -(delta * speed), position.y))

	move_and_slide()

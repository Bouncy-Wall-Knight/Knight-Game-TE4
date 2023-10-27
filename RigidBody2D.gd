extends RigidBody2D


var move_speed = 200
var gravity = Vector2(0, 800)
var slope_threshold = deg_to_rad(45) # Adjust this angle as needed

func _physics_process(delta):
	var velocity = Vector2()
	velocity += gravity * delta

	var slide_vector = calculate_slide_vector()
	velocity.x = move_speed
	move_and_slide()

func calculate_slide_vector():
	var slide_vector = Vector2()
	var collision_info = move_and_collide(Vector2(0, 1)) # Cast a ray downwards
	if collision_info:
		var slope_angle = abs(collision_info.normal.angle_to(Vector2.UP))
		if slope_angle >= slope_threshold:
			slide_vector = collision_info.normal.slide(Vector2(0, -1))
	return slide_vector

#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("Jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("Move_left", "Move_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()
extends CharacterBody2D

@export var speed = 50
@export var air_resistance = 10
@export var gravity =  10
@export var jump_force = 5
@export var max_jump = 1000
@export var min_jump = 100
@export var bounce = 20
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cs2d = $CollisionShape2D
@onready var charge_bar = $charge_bar
@onready var ray_left = $angle_ray
@onready var ray_right = $ray_right
var last_velocity = Vector2(0,0)
var last_pos = Vector2(0,0)
var jumps_air = 1
var hold_jump = false
var charge = 0
var x_direction = 1
var facing_dir = 1
var x_speed = 0
var stopped = false
var angle_ray = 0
var slope_angle = 0
func _ready():
	
#	last_velocity = velocity
#	last_pos = position
	set_wall_min_slide_angle(0.3)
#	max_slides = 999999
#	floor_stop_on_slope = false
#	floor_constant_speed = false
#	set_floor_snap_length(0.7)
#	velocity.x = 20
func _physics_process(delta):
	angle_ray = (ray_left if ray_right.get_collider() == null else ray_right)
	charge_bar.value = 100*charge/max_jump
	velocity.y += gravity
	velocity.x = 0
	if angle_ray.get_collider() != null:
		print(angle_ray.get_collider().rotation)
		slope_angle = angle_ray.get_collider().rotation
		velocity.x = slope_angle * 200
		if velocity.x > 200:
			velocity.x = 200
#	if x_direction != 0:
#		velocity.x = lerp(velocity.x, float(x_direction * speed), 0.1)
#	else:
#		velocity.x = lerp(velocity.x, 0.0, 0.1)
	if velocity.y > 200:
		velocity.y = 200
	if is_on_floor() and !is_on_slope():
		if Input.is_action_just_pressed("Move_left"):
			x_direction = -1
		if Input.is_action_just_pressed("Move_right"):
			x_direction = 1
		facing_dir = x_direction
		jumps_air = 0
		stopped = false
		if Input.is_action_just_pressed("Jump"):
			hold_jump = true

		if Input.is_action_just_released("Jump") and hold_jump == true:
			if Input.is_key_pressed(KEY_SHIFT):
				velocity.y -= charge*0.6
				x_speed = speed * 2
			else:
				velocity.y -= charge
				x_speed = speed
			facing_dir = x_direction
			gravity = 10
			hold_jump = false
			charge = min_jump
			stopped = false	

	if !is_on_floor():
		if is_on_wall():
#			velocity.x = -20 * velocity.x
			x_direction = -x_direction
			stopped = true
		if !stopped:
			velocity.x = x_speed * x_direction
			if x_speed < 10:
				x_speed -= 1*x_direction
		else: 
			velocity.x = bounce * -x_direction
			if bounce < 10:
				bounce -= -1*x_direction

	if hold_jump:
		charge += jump_force
		if charge > max_jump:
			charge = max_jump
		charge_bar.visible = true
	else:
		charge_bar.visible = false
	print(" ",velocity.x)
	
	move_and_slide()
	
	if x_direction != 0 and is_on_floor():
		if is_on_slope():
			sprite.flip_h = slope_angle < 0
#			print(position.x - last_pos[0] == 0, position.x, "   ",last_pos[0])
		else:
			sprite.flip_h =  (facing_dir == -1)
			sprite.position.x = 6*facing_dir
	update_animations(facing_dir)
#	last_velocity = velocity

func update_animations(x_direction):
	
	if is_on_floor():
		if is_on_slope():
			ap.play("slide")
		elif !hold_jump:
			ap.play("idle")
		else:
			ap.play("crouch")
	elif hold_jump:
		ap.play("crouch")
	else:
		if velocity.y < 0:
			ap.play("jump")
		else:
			ap.play("fall")
			
			
			
func is_on_slope():
	if angle_ray.get_collider() != null:
		return angle_ray.get_collider().rotation != 0
	else:
		return false
	

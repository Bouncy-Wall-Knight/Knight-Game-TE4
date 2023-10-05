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

class_name Player

@export var speed = 50
@export var air_resistance = 10
@export var gravity =  10
@export var jump_force = 5
@export var max_jump = 1000
@export var min_jump = 100
@export var bounce = 0.4
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var uppright_cs = $UpprightCS2d
@onready var crouch_cs = $crouchCS2d
@onready var slide_cs = $SlideCS2d
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
var start_pos
var slide_cs_rotation

func _ready():
	start_pos = position
	slide_cs.disabled = true
	crouch_cs.disabled = true
	slide_cs_rotation = slide_cs.rotation_degrees
	set_wall_min_slide_angle(0.1)
	
func _physics_process(delta):
	angle_ray = (ray_left if ray_right.get_collider() == null else ray_right)
	
	charge_bar.value = 100*charge/max_jump
	
	velocity.y += gravity

		
	if !is_on_slope() and is_on_floor():
		velocity.x = 0
		
	if is_on_slope() and velocity.y > 0:
		
		slope_angle = angle_ray.get_collider().rotation
		velocity.x += slope_angle * gravity
		velocity.y += abs(velocity.x * 1.2) 
		
		if abs(velocity.x) > 120:
			velocity.x = 120 if velocity.x > 0 else -120
		x_speed = velocity.x * 0.8
	
	if !is_on_floor() and !is_on_slope():
		if is_on_wall() and (angle_ray.get_collider() == null or velocity.y > 0):
#			velocity.x = -20 * velocity.x
			x_speed = -x_speed
			x_speed *= bounce
#			x_direction = -x_direction
		velocity.x = x_speed
		

	if is_on_floor() and !is_on_slope():
		if Input.is_action_just_pressed("Move_left"):
			x_direction = -1
			
		if Input.is_action_just_pressed("Move_right"):
			x_direction = 1
		jumps_air = 0
		stopped = false
		
		if Input.is_action_just_pressed("Jump"):
			hold_jump = true
			charge = min_jump
			
		if Input.is_action_just_released("Jump") and hold_jump == true:
			if Input.is_key_pressed(KEY_SHIFT):
				velocity.y -= charge*0.6
				x_speed = speed * 2 * x_direction
			else:
				velocity.y -= charge
				x_speed = speed * x_direction
			hold_jump = false
			charge = min_jump
			stopped = false	


	if hold_jump:
		charge += jump_force
		if charge > max_jump:
			charge = max_jump
		charge_bar.visible = true
	else:
		charge_bar.visible = false

	if velocity.y > 200:
		velocity.y = 200
	update_animations()
	update_shape()
	move_and_slide()

#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		if collision.get_collider().get_parent() is Trap:
#			position = start_pos


func update_animations():
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
	
func update_shape():
	var sprite_padding = 6
	slide_cs.disabled = true
	crouch_cs.disabled = true
	uppright_cs.disabled = true

	if is_on_slope() and is_on_floor():
		slide_cs.disabled = false
#		sprite.rotation = slope_angle
		rotation = slope_angle
		sprite_padding = 0
	else:
		uppright_cs.disabled = false
		sprite_padding = 6
		rotation = 0
	if x_direction != 0 and is_on_floor():
		if is_on_slope():
			sprite.flip_h = slope_angle < 0
			if slope_angle < 0:
				slide_cs.rotation = -deg_to_rad(10) * x_direction
			else:
				slide_cs.rotation = deg_to_rad(10) * x_direction
		else:
			sprite.flip_h = (x_direction == -1)
			sprite.position.x = sprite_padding * x_direction
			
func is_on_slope():
	if angle_ray.get_collider() != null:
		return angle_ray.get_collider().rotation != 0
	else:
		return false
	

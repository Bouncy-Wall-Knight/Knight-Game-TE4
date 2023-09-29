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
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
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
@export var min_jump = 50
@export var bounce = 20
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cs2d = $CollisionShape2D
@onready var charge_bar = $charge_bar
var jumps_air = 1
var hold_jump = false
var charge = 0
var x_direction = 1
var x_speed = 0
var stopped = false
func _physics_process(delta):
	charge_bar.value = 100*charge/max_jump
	
	if is_on_floor():
		if Input.is_action_just_pressed("Move_left"):
			x_direction = -1
		if Input.is_action_just_pressed("Move_right"):
			x_direction = 1
		jumps_air = 0
		velocity.x = 0
		stopped = false
	if !is_on_floor():
		if is_on_wall():
			velocity.x = -20 * x_direction
			stopped = true
		if velocity.y < 200:
			velocity.y += gravity
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
			
	if Input.is_action_just_pressed("Jump") and (is_on_floor()):
		hold_jump = true
		
	if Input.is_action_just_released("Jump") and (is_on_floor()):
		velocity.y -= charge
		hold_jump = false
		charge = min_jump
		x_speed = speed
		stopped = false
		
	if x_direction != 0:
		sprite.flip_h =  (x_direction == -1)
		sprite.position.x = 6*x_direction
	
	update_animations(x_direction)
	
	move_and_slide()
	
func update_animations(x_direction):
	if is_on_floor():
		if !hold_jump:
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

extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

@onready var walkAnimation := $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		walkAnimation.play("run")
		walkAnimation.scale.x = direction
		if !is_jumping:
			walkAnimation.play("run")
	elif is_jumping:
		walkAnimation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walkAnimation.play("idle")

	move_and_slide()

extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get left/right input direction (-1 for left, 1 for right, 0 for none)
	var direction := Input.get_axis("move_left", "move_right")

	# Apply movement speed
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Play animations using separate left/right animations
	if not is_on_floor():
		animated_sprite.play("idle")
	elif direction > 0:
		animated_sprite.play("run_right")
	elif direction < 0:
		animated_sprite.play("run_left")
	else:
		animated_sprite.play("idle")

	move_and_slide()

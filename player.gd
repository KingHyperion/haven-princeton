extends CharacterBody2D

# Movement & Jump Settings
const SPEED = 130.0
const JUMP_VELOCITY = -400.0

# Bouncy Floor Settings
const BOUNCE_DECAY = 0.75       # Keeps 75% of speed each bounce (must be less than 1.0)
const JUMP_BOOST = -150.0       # Extra upward speed added when jumping on impact
const MAX_BOUNCE_SPEED = -800.0 # Prevents bouncing infinitely high if holding jump
const MIN_BOUNCE_SPEED = 100.0  # Stops tiny micro-bounces so player can stand still
const JUMP_BUFFER_TIME = 0.15   # 150ms forgiveness window if jump is pressed slightly early

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Track Jump Input Buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	elif jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# 3. Normal Ground Jump (when standing still on the floor)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0

	# 4. Left / Right Movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 5. Animations
	if not is_on_floor():
		animated_sprite.play("idle")
	elif direction > 0:
		animated_sprite.play("run_right")
	elif direction < 0:
		animated_sprite.play("run_left")
	else:
		animated_sprite.play("idle")

	# 6. Record falling speed right before hitting the floor
	var fall_speed = velocity.y

	# 7. Move the character
	move_and_slide()

	# 8. Bounce whenever we land on ANY floor after falling
	if fall_speed > 0 and is_on_floor():
		# Calculate degraded bounce speed
		var next_bounce = -fall_speed * BOUNCE_DECAY

		# If holding jump (or pressed right before landing), bounce even higher!
		if Input.is_action_pressed("jump") or jump_buffer_timer > 0:
			next_bounce += JUMP_BOOST
			jump_buffer_timer = 0.0

		# Cap the maximum bounce height
		next_bounce = max(next_bounce, MAX_BOUNCE_SPEED)

		# Apply bounce if strong enough, otherwise come to a full stop
		if abs(next_bounce) > MIN_BOUNCE_SPEED:
			velocity.y = next_bounce
		else:
			velocity.y = 0.0

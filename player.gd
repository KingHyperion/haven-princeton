extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -400.0

const BOUNCE_DECAY = 0.75       
const JUMP_BOOST = -150.0       
const MAX_BOUNCE_SPEED = -800.0 
const MIN_BOUNCE_SPEED = 100.0  
const JUMP_BUFFER_TIME = 0.15   

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_key_pressed(KEY_SPACE):
		jump_buffer_timer = JUMP_BUFFER_TIME
	elif jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction*SPEED
	else:
		velocity.x = 0
	

	if not is_on_floor():
		animated_sprite.play("idle")
	elif direction > 0:
		animated_sprite.play("run_right")
	elif direction < 0:
		animated_sprite.play("run_left")
	else:
		animated_sprite.play("idle")

	var fall_speed = velocity.y

	move_and_slide()

	if fall_speed > 0 and is_on_floor():
		var next_bounce = -fall_speed * BOUNCE_DECAY

		if Input.is_action_pressed("jump") or jump_buffer_timer > 0:
			next_bounce += JUMP_BOOST
			jump_buffer_timer = 0.0

		next_bounce = max(next_bounce, MAX_BOUNCE_SPEED)

		if abs(next_bounce) > MIN_BOUNCE_SPEED:
			velocity.y = next_bounce
		else:
			velocity.y = 0.0

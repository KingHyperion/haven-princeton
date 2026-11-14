extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
var bounce_timer = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle regular jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get left/right input direction (-1 for left, 1 for right, 0 for none)
	var direction := Input.get_axis("move_left", "move_right")

	# Apply movement speed
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print("Hit: ", collider)
		
		if collider is TileMapLayer:
			var hit_pos = collision.get_position() - collision.get_normal()
			var tile_coords = collider.local_to_map(collider.to_local(hit_pos))
			var tile_data = collider.get_cell_tile_data(tile_coords)
			
			print("Coords: ", tile_coords, " Data: ", tile_data)
			
			if tile_data:
				var bounce = tile_data.get_custom_data("bouncy_forcy")
				print("Bounce value: ", bounce)
				if bounce != 0.0:
					velocity.y = bounce
	move_and_slide()

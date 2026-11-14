class_name Boomrang
extends CharacterBody2D

@export var speed: float = 300.0
@export var max_return_time: float = 2.5

@onready var animated_sprite = $AnimatedSprite2D

var player: Node2D
var direction: Vector2 = Vector2.RIGHT
var is_returning: bool = false
var return_timer: float = 0.0
var alive_timer: float = 0.0

func launch(thrower: Node2D, aim_dir: Vector2) -> void:
	player = thrower
	direction = aim_dir
	add_collision_exception_with(player)
	
	if animated_sprite and animated_sprite.sprite_frames.has_animation("spin"):
		animated_sprite.play("spin")
	elif animated_sprite:
		animated_sprite.play()

func _physics_process(delta: float) -> void:
	alive_timer += delta

	if animated_sprite:
		animated_sprite.rotation += 20.0 * delta

	if not is_returning:
		var step = direction * speed * delta
		var collision = move_and_collide(step)

		if collision:
			direction = direction.bounce(collision.get_normal()).normalized()
	else:
		return_timer += delta
		if return_timer >= max_return_time or not is_instance_valid(player):
			instant_resummon()
			return

		var target_pos = player.get_player_center()
		var to_player = target_pos - global_position
		if to_player.length() < 16.0 and alive_timer > 0.2:
			catch_boomerang()
		else:
			direction = to_player.normalized()
			global_position += direction * (speed * 1.2) * delta

func force_return() -> void:
	is_returning = true
	collision_mask = 0

func catch_boomerang() -> void:
	if is_instance_valid(player):
		player.active_boomerang = null
	queue_free()

func instant_resummon() -> void:
	catch_boomerang()

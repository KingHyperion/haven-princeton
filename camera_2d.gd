extends Camera2D

@export var target: Node2D
@export var tilemap: TileMapLayer
@export var tile_size: int = 16
@export var grid_width: int = 26
@export var follow_speed: float = 10.0

var locked_x: float
var smooth_y: float

func _ready() -> void:
	make_current()
	
	if tilemap:
		if tilemap.tile_set:
			tile_size = tilemap.tile_set.tile_size.x
		var used_rect: Rect2i = tilemap.get_used_rect()
		var left_edge_px: float = tilemap.global_position.x + (used_rect.position.x * tile_size)
		var total_width_px: float = used_rect.size.x * tile_size
		locked_x = left_edge_px + (total_width_px / 2.0)
	else:
		locked_x = (grid_width * tile_size) / 2.0
		
	global_position.x = locked_x
	if target:
		smooth_y = target.global_position.y

func _physics_process(delta: float) -> void:
	global_position.x = locked_x
	
	if target:
		# Smoothly track the target's Y position
		smooth_y = lerp(smooth_y, target.global_position.y, follow_speed * delta)
		# Snap to whole pixels (or tile_size) to keep pixel art crisp
		global_position.y = round(smooth_y)

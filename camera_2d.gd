extends Camera2D

@export var target: Node2D
@export var tilemap: TileMapLayer
@export var tile_size: int = 16
@export var grid_width: int = 26

var locked_x: float

func _ready() -> void:
	make_current()
	
	if tilemap:
		var used_rect: Rect2i = tilemap.get_used_rect()
		var left_edge_px: float = tilemap.global_position.x + (used_rect.position.x * tile_size)
		var total_width_px: float = used_rect.size.x * tile_size
		locked_x = left_edge_px + (total_width_px / 2.0)
	else:
		locked_x = (grid_width * tile_size) / 2.0
		
	global_position.x = locked_x

func _process(_delta: float) -> void:
	global_position.x = locked_x
	
	if target:
		var snapped_y: float = floor(target.global_position.y / tile_size) * tile_size + (tile_size / 2.0)
		global_position.y = snapped_y

extends Area2D
@export var coins: int = 0
@export var destination: Marker2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)




func _on_body_entered(body: Node2D) -> void:
	if body is Player and coins > 3:
		print("Player contacted the sprite!")
	elif body is Player and coins <= 3:
		print("More coins needed")
		body.teleport(destination.global_position)

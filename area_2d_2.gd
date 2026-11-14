extends Area2D
@export var coins: int = 0
@export var destination: Marker2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)




func _on_body_entered(body: Node2D) -> void:
	if body is Player and coins > 3:
		print("Player contacted the sprite!")
		body.global_position = Vector2(325, -150)
		body.velocity = Vector2.ZERO
		
	elif body is Player and coins <= 3:
		print("More coins needed")

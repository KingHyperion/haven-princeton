extends Area2D

@export var required_coins: int = 3

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.coins >= required_coins:
			match name:
				"Portal":
					body.global_position = Vector2(325, -150)
				"Portal2":
					body.global_position = Vector2(315, -280)
				"Portal3":
					body.global_position = Vector2(0, -450)
				"Portal4":
					body.global_position = Vector2(295, -600)
				"Portal5":
					body.global_position = Vector2(295, -710)
				"Portal6":
					body.global_position = Vector2(-5, -905)
			
			body.velocity = Vector2.ZERO
			body.coins = 0
		else:
			print("More coins needed")

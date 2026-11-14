extends CollisionShape2D

@export var coins: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Boomrang:
		print("Boomrang contacted the coin!")
		# Add 1 to the player's coin count (adjust 'body.player' to match how your boomerang tracks the player)
		if body.player:
			body.player.coins += 1
		queue_free()

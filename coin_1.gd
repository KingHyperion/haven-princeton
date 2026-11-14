extends Area2D

@export var coin_value: int = 1
@export var destination: Marker2D

var collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_boomrang_entered)

func _on_boomrang_entered(body: Node2D) -> void:
	if collected:
		return

	if body is Boomrang:
		collected = true
		if is_instance_valid(body.player):
			body.player.coins += coin_value
			print(body.player.coins)
		hide()
		$CollisionShape2D.set_deferred("disabled", true)

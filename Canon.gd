extends Node2D

@onready var main = get_tree().get_root().get_node("ani_sandbox")
@onready var projectile = load("res://projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	shoot() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.SpawnPos = global_position
	instance.SpawnRot = rotation
	main.add_child.call_deferred(instance)

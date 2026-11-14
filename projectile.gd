extends CharacterBody2D

@export var SPEED = 100

var dir : float
var SpawnPos : Vector2
var SpawnRot: float

func _ready():
	global_position = SpawnPos
	global_rotation = SpawnRot

func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()

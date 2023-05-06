class_name VelocityComponent extends Node

@export
var speed: float = 200.0

var velocity: Vector2 = Vector2.ZERO

func _ready():
	set_process(false)


func accelerate(to: Vector2):
	velocity = Vector2(
		lerp(velocity.x, (to.normalized() * speed).x, 0.15),
		lerp(velocity.y, (to.normalized() * speed).y, 0.15),
	)


func decelerate():
	velocity = Vector2(
		lerp(velocity.x, 0.0, 0.15),
		lerp(velocity.y, 0.0, 0.15),
	)

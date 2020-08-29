extends Area2D

export (String) var target
var inRange = false

func changeDirection(direction):
	if direction.x == Vector2.LEFT.x:
		if sign(scale.x) == 1:
			position.x *= -1
			scale.x *= -1
	if direction.x == Vector2.RIGHT.x:
		if sign(scale.x) == -1:
			position.x *= -1
			scale.x *= -1

func canHit() -> bool:
	return inRange

func _on_body_entered(body):
	if target in body.name:
		inRange = true

func _on_body_exited(body):
	if target in body.name:
		inRange = false


func _on_direction_changed(new_direction):
	changeDirection(new_direction)

extends KinematicBody2D
class_name Actor

export (String) var team
export var speed = Vector2(100, 1000)
export var gravity = 3000.0

onready var HitZone = $HitZone

var _velocity = Vector2()
var _isAttacking = false

func _setAnimation() -> void:
	if _velocity.y < 0: $AnimatedSprite.play("jump")
	elif _velocity.y > 0: $AnimatedSprite.play("fall")
	elif _velocity.x != 0:
		$AnimatedSprite.play("run")
		_setDirection()
	else: $AnimatedSprite.play("idle")

func _setDirection() -> void:
	if _velocity.x < 0:$AnimatedSprite.flip_h = true
	if _velocity.x > 0: $AnimatedSprite.flip_h = false

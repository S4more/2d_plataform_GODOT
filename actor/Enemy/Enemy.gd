extends KinematicBody2D

export (String) var team = "Mob"

const FLOOR = Vector2(0, -1)

var is_dead = false
onready var health = $Health

var gravity = 1600
var attackCount = 0

signal direction_changed(new_direction)

var look_direction = Vector2.LEFT setget set_look_direction

func _ready():
	health.set_max(50)
	health.current = 50

func _apply_gravity(delta):
	return gravity * delta

func set_look_direction(value):
	if value.x > 0:
		look_direction = value
	elif value.x < 0:
		look_direction = value
	if value.x == 0:
		return
		
	emit_signal("direction_changed", value)

#func _physics_process(delta):
#	if is_dead: return
#	_setAnimation()
#
#
#	match state:
#		IDLE:
#			direction = getDirection()
#			_seek_player()
#			_velocity = calculate_move_velocity(_velocity, direction, Vector2(0, speed.y))
#			_velocity = move_and_slide(_velocity, Vector2.UP)
#			return
#		WANDER:
#			pass
#
#		CHASE:
#			var player = playerDetetectionZone.player
#			if player != null:
#				var distance = player.get_global_position().x - self.get_global_position().x
#				direction.x = sign(distance)
#				if HitZone.canHit():
#					state = ATTACK
#					return
#			else:
#				state = IDLE
#
#		ATTACK:
##			if not HitZone.canHit():
##				state = CHASE
#			return
#	pass
#
##func changeHitbox():
##	HitZone.changeDirection()
##	weapon.changeDirection()
#
#func getDirection() -> Vector2:
#	if is_on_wall() or not $RayCast2D.is_colliding():
#		$RayCast2D.position.x *= -1
#		return Vector2(direction.x * -1, 1)
#	return Vector2(direction.x, 1)
#
#func calculate_move_velocity(
#		linear_velocity: Vector2,
#		direction: Vector2,
#		speed: Vector2
#	) -> Vector2:
#
#	var out: = linear_velocity
#	out.x = speed.x * direction.x
#	if direction.y == -1.0:
#		out.y = speed.y * direction.y
#	return out
#
#func dead():
#	is_dead = true
#	_velocity = Vector2(0, 0)
#	$CollisionShape2D.call_deferred("set_disabled", true)
#	$AnimatedSprite.play("death")
#	$Timer.start()
#
#func _on_Timer_timeout():
#	queue_free()
#
#
#func _on_Health_depleted():
#	dead()

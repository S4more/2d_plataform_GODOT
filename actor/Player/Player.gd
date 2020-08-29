extends KinematicBody2D

const FIREBALL = preload("res://combat/magic/Fireball.tscn")
onready var Inventory = get_owner().get_owner().get_node("InterfaceLayer").get_node("Inventory")
#onready var weapon = $bow
onready var arrow = FIREBALL
onready var anim_actor = get_node("AnimatedSprite")
onready var health = $Health

var gravity = 1600
export (int) var maxJump = 2
export (String) var team = "Player" 
var attackCount = 0
var jumpCount = 0

signal direction_changed(new_direction)

var look_direction = Vector2.RIGHT setget set_look_direction

func take_damage(attacker, amount, effect = null):
	if is_a_parent_of(attacker):
		return
	$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
	$Health.take_damage(amount, effect)

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.disabled = value

func set_look_direction(value):
	if value.x > 0:
		look_direction = value
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	if value.x < 0:
		look_direction = value
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	if value.x == 0:
		return
	emit_signal("direction_changed", value)

#var lastDirection = Vector2(1, 0)
#var _direction = Vector2()
#var rollcd = false
#var _speedModifier = Vector2.ZERO
#
#enum {
#	IDLE,
#	RUNNING,
#	ATTACKING,
#	ROLLING,
#	JUMPING,
#	FALLING
#}
#
#var state = IDLE
#
#func _ready():
#	health.initialize()
#
#func _handle_move_input():
#	#_direction =  getDirection()
#	pass
#
#func _apply_gravity(delta):
#	_velocity.y += gravity * get_physics_process_delta_time()
#
#func _physics_process(delta):	
#	lastDirection = _direction if _direction.x != 0 else lastDirection
#	if state != ROLLING:
#		pass
#	else:
#		_direction = lastDirection
#
#
#func _apply_movement():
#	var is_jump_interrupted = Input.is_action_just_released("ui_up") and _velocity.y < 0.0
#	_velocity = calculate_move_velocity(_velocity, _direction, speed + _speedModifier, is_jump_interrupted)
#	_velocity = move_and_slide(_velocity, Vector2.UP)
#
#func _setAnimation() -> void:
#	_setDirection()
#	_setHit(_velocity)
#
#func jump() -> void:
#	_direction.y = -1.0 if Input.is_action_just_pressed("ui_up") else 1.0
#
#func roll() -> void:
#	state = ROLLING
#	_speedModifier = Vector2(speed.x * 1.3, 0)
#	rollcd = true
#	$RollTimer.start()
#
#func _on_RollTimer_timeout() -> void:
#	state = IDLE
#	_speedModifier = Vector2.ZERO
#	$RollCooldown.start()
#
#func _setHit(direction: Vector2) -> void:
#	if direction.x > 0:
#		if sign($Position2D.position.x) == -1:
#			$Position2D.position.x *= -1
#			weapon.setDirection(false)
#	if direction.x < 0:
#		if sign($Position2D.position.x) == 1:
#			$Position2D.position.x *= -1
#			weapon.setDirection(true)
#
#func getDirection() -> Vector2:
#	return Vector2(
#		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
#		-1.0 if Input.is_action_just_pressed("ui_up") and is_on_floor() else 1.0
#	)
#
#func calculate_move_velocity(
#		linear_velocity: Vector2,
#		direction: Vector2,
#		speed: Vector2,
#		is_jump_interrupted: bool
#	) -> Vector2:
#	var out: = linear_velocity
#	out.x = speed.x * direction.x
#	if direction.y == -1.0:
#		out.y = speed.y * direction.y
#	if is_jump_interrupted:
#		out.y = 0.0
#	return out
#
#
#func _on_RollCooldown_timeout():
#	rollcd = false
#
#func _on_Timer_timeout():
#	$CollisionShape2D.call_deferred("set_disabled", true)
#	get_tree().change_scene("res://StageOne.tscn")
#
#
#func _on_Health_depleted():
#	$AnimatedSprite.play("death")
#	$Timer.start()

extends State

export (Vector2) var speed = Vector2.ZERO
export (float) var patrolRange = 100
var initialPatrolPosition
var velocity
var isReturning
var initDirection
var leftLimit = 0
var rightLimit = 0
var direction = Vector2.LEFT

func enter():
	initialPatrolPosition = owner.position
	owner.get_node("AnimatedSprite").play("run")
	velocity = Vector2.ZERO
	leftLimit = patrolRange
	rightLimit = patrolRange

func update_look_direction(direction):
	owner.set_look_direction(direction)
	if direction.x < 0:
		owner.get_node("AnimatedSprite").flip_h = true
	if direction.x > 0:
		 owner.get_node("AnimatedSprite").flip_h = false

func update(delta):
	var player = owner.get_node("PlayerDetectionZone").player
	if player:
		emit_signal("finished", "chase")
	
	if owner.is_on_wall():
		if direction == Vector2.LEFT:
			direction = Vector2.RIGHT
			update_look_direction(direction)
		elif direction == Vector2.RIGHT:
			direction = Vector2.LEFT
			update_look_direction(direction)
			
	else:
		#If going right
		if owner.position.x - initialPatrolPosition.x > rightLimit:
			direction = Vector2.LEFT
			update_look_direction(direction)
		elif owner.position.x < initialPatrolPosition.x - leftLimit:
			direction = Vector2.RIGHT
			update_look_direction(direction)
	
	move(direction, delta)

func move(direction, delta):
	velocity.x = direction.x * speed.x
	velocity.y = owner.gravity * delta
	owner.move_and_slide(velocity, Vector2.UP)
#
#	if not input_direction.x:
#		emit_signal("finished", "idle")
#	if not owner.is_on_floor():
#		emit_signal("finished", "fall")

extends State

export (Vector2) var speed = Vector2.ZERO
var velocity
var player = null

func enter():
	owner.get_node("AnimatedSprite").play("run")
	player = owner.get_node("PlayerDetectionZone").player
	velocity = Vector2.ZERO

func update_look_direction(direction):
	owner.set_look_direction(direction)
	if direction.x < 0:
		owner.get_node("AnimatedSprite").flip_h = true
	if direction.x > 0:
		 owner.get_node("AnimatedSprite").flip_h = false
	
func update(delta):
	player = owner.get_node("PlayerDetectionZone").player
	if not player:
		emit_signal("finished", "patrol")
		return
	if owner.get_node("HitRange").canHit():
		emit_signal("finished", "attack")
		return
	

	var direction = (player.position - owner.position)
	direction = Vector2(sign(direction.x), sign(direction.y))
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

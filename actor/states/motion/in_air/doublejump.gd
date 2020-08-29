extends "../motion.gd"

export (float) var jumpForce = 700.0

func enter():
	owner.anim_actor.play("jump")
	velocity.y = -1 * jumpForce
	owner.jumpCount += 1

func update(_delta):
	speed.x = max_walk_speed
	#print(initialPosition.y - owner.get_position().y)
	
	if velocity.y > 0:
		emit_signal("finished", "fall")
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	var collision_info = move(speed, input_direction)
	
func move(speed, direction):
	velocity.x = direction.x * speed.x / 1.2
	velocity.y += apply_gravity()
	owner.move_and_slide(velocity, Vector2.UP)

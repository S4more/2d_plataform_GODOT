extends "../motion.gd"

export (float) var jumpForce = 700.0
var initialPosition = Vector2()

func enter():
	owner.anim_actor.play("jump")
	initialPosition = owner.get_position()
	velocity.y = -1 * jumpForce

func handle_input(event):
	if event.is_action_pressed("jump") and owner.jumpCount == 1:
			get_parent().can_attack = true
			emit_signal("finished", "doubleJump")
	if event.is_action_pressed("jump"):
		owner.jumpCount += 1

func update(_delta):
	speed.x = max_walk_speed
	
	if velocity.y > 0:
		emit_signal("finished", "fall")
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	var collision_info = move(speed, input_direction)
	
func move(speed, direction):
	velocity.x = direction.x * speed.x / 1.2
	velocity.y += apply_gravity()
	owner.move_and_slide(velocity, Vector2.UP)

extends "../on_ground/move.gd"

func enter():
	speed = Vector2()
	velocity = Vector2()
	owner.anim_actor.play("fall")

func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")
	if event.is_action_pressed("jump"):
		if owner.jumpCount <= owner.maxJump:
			emit_signal("finished","jump")

func update(_delta):
	if owner.is_on_floor():
		owner.jumpCount = 0
		emit_signal("finished", "idle")
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	speed.x = max_walk_speed
	var collision_info = move(speed, input_direction)
	if not collision_info:
		return
		
	if speed.x == max_run_speed and collision_info.collider.is_in_group("environment"):
		return null

func move(speed, direction):
	velocity.x = direction.x * speed.x / 1.2
	velocity.y += apply_gravity()
	owner.move_and_slide(velocity, Vector2.UP)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)

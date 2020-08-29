extends "on_ground.gd"

func enter():
	speed = Vector2(0.0,0.0)
	velocity = Vector2.ZERO
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimatedSprite").play("run")
	
func handle_input(event):
	return .handle_input(event)
	
func update(_delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	if not input_direction.x:
		emit_signal("finished", "idle")
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
	
	speed.x = max_run_speed if Input.is_action_pressed("run") else max_walk_speed
	var collision_info = move(speed, input_direction)
	if not collision_info:
		return

	if speed.x == max_run_speed and collision_info.collider.is_in_group("environment"):
		return null

func move(speed, direction):
	velocity.x = direction.x * speed.x
	velocity.y = apply_gravity()
	owner.move_and_slide(velocity, Vector2.UP)
#	if owner.get_slide_count() == 0:
#		return
#	return owner.get_slide_collision(0)
			

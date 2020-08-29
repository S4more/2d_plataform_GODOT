extends "on_ground.gd"

func enter():
	owner.get_node("AnimatedSprite").play("idle")
	
func handle_input(event):
	return .handle_input(event)
	
func update(_delta):
	var input_direction = get_input_direction()
	if input_direction.x:
		emit_signal("finished", "move")
	if not owner.is_on_floor():
		emit_signal("finished", "fall")

func move():
	var velocity = Vector2.ZERO
	velocity.x = 0
	owner.move_and_slide(velocity, Vector2.UP)

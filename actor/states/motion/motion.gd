extends State
class_name Motion

var speed = Vector2()
var velocity = Vector2()

export(float) var max_walk_speed = 150
export (float) var max_run_speed = 300

func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = 1.0
	return input_direction
	
func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
	if direction.x < 0:
		owner.anim_actor.flip_h = true
	if direction.x > 0:
		 owner.anim_actor.flip_h = false

func apply_gravity():
	return owner.gravity * get_physics_process_delta_time()

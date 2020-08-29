extends Motion

export (float) var rollSpeed = 300
export (float) var cooldownTime = 0.5
var cooled = true
var active = true


func enter():
	speed = Vector2(0.0,0.0)
	velocity = Vector2.ZERO
	
	$Cooldown.wait_time = cooldownTime
	active = true
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimatedSprite").play("roll")
	
func _ready():
	# warning-ignore:return_value_discarded
	owner.get_node("AnimatedSprite").connect("animation_finished", self, "_on_animation_finished")
	
func handle_input(event):
	if event.is_action_pressed("jump") and owner.is_on_floor():
		emit_signal("finished", "jump")
	return .handle_input(event)

func update(_delta):
	if not active:
		owner.set_collision_layer_bit(2, true)
		emit_signal("finished", "idle")
		return
	if not owner.is_on_floor():
		velocity.y += apply_gravity()
	else:
		velocity.y = apply_gravity()
	
	owner.set_collision_layer_bit(2, false)
	speed.x = rollSpeed
	var collision_info = move(speed, owner.look_direction)
	if not collision_info:
		return

	if speed.x == max_run_speed and collision_info.collider.is_in_group("environment"):
		return null

func move(speed, direction):
	velocity.x = direction.x * speed.x
	owner.move_and_slide(velocity, Vector2.UP)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)
			

func _on_animation_finished():
	active = false
	$Cooldown.start()

func _on_Cooldown_timeout():
	cooled = true

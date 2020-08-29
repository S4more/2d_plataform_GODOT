extends ActionStateMachine

func _state_logic(delta):
	if state == states.active:
		parent.shoot()
		state = states.postanimation
		parent.active = false
	
	elif state == states.postanimation:
		if parent.parent.anim_actor.frame == parent.parent.anim_actor.get_sprite_frames().get_frame_count("attack") - 1:
			state = states.heated
			parent.get_node("CollisionShape2D").set_disabled(true)
	
	
	elif parent.active:
		state = states.preanimation
		parent.parent.anim_actor.set_frame(0)
		parent.active = false
	
	elif state == states.preanimation:
		if parent.parent.anim_actor.frame == 8:
			state = states.active
			parent.get_node("CollisionShape2D").set_disabled(false)

	parent.state = state

func _on_Duration_timeout():
	parent.active = false
	state = states.heated
	get_parent().get_node("Cooldown").start()

func _on_Cooldown_timeout():
	state = states.cooled

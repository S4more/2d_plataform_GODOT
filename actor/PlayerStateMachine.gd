extends StateMachine

#air attack related
var can_attack = true

func _ready():
	states_map = {
		"idle" : $Idle,
		"move" : $Move,
		"attack" : $Attack,
		"jump" : $Jump,
		"doubleJump":$doubleJump,
		"fall" : $Fall,
		"roll" : $Roll,
		"shoot": $Shoot,
		#"stagger" : $Stagger
	}

func _change_state(state_name):
	if not _active:
		return
	#Priority
#	if state_name in ["attack"]:
#		states_stack.push_front(states_map[state_name])
#	if state_name == "jump" and current_state == $Move:
#		$Jump.initialize($Move.speed, $Move.velocity)
	
	._change_state(state_name)

func _input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
	
	if owner.is_on_floor():
		owner.jumpCount = 0
		owner.attackCount = 0
		can_attack = true
	
	if event.is_action_pressed("roll") and $Roll.cooled:
		if current_state in [$Roll]:
			return
		_change_state("roll")
		return
	
	if event.is_action_pressed("shoot"):
		if current_state in [$Roll, $Shoot, $Attack]:
			return
		if owner.attackCount < owner.maxJump and can_attack:
			_change_state("shoot")
			can_attack = false
		return
	
	if event.is_action_pressed("attack"):
		if current_state in [$Attack, $Shoot]:
			return
		if owner.attackCount < owner.maxJump and can_attack:
			_change_state("attack")
			can_attack = false
		return
		
	current_state.handle_input(event)


#func _state_logic(delta):	
#	parent._direction = Vector2.ZERO
#
#	if [states.idle, states.run, states.jump, states.fall].has(state):
#		if Input.is_action_pressed("ui_focus_next"):
#			state = states.attack
#
#		if Input.is_action_just_pressed("roll"):
#			state = states.roll
#
#		parent._direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#
#
#	if [states.idle, states.run, states.attack].has(state):
#		if Input.is_action_pressed("ui_down"):
#			parent.set_collision_mask_bit(1, false)
#
#		if parent.is_on_floor():
#			if Input.is_action_pressed("ui_up"):
#				parent._direction.y = -1.0
#
#	if state == states.attack:
#		if parent.weapon.state == 0:
#			parent.weapon.attack()
#
#		parent._direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#		parent._direction.x *= 0.5
#
#	if state == states.roll:
#		if parent.get_node("Roll").state == 0:
#			parent.get_node("Roll").start()
#
#		return
#
#
#	parent._setHit(parent._direction)
#	parent._setDirection()
#	parent._handle_move_input()
#	parent._apply_gravity(delta)
#	parent._apply_movement()
#
#
#func _get_transition(delta):
#	match state:
#		states.idle:
#			if !parent.is_on_floor():
#				if parent._velocity.y < 0:
#					return states.jump
#				elif parent._velocity.y >= 0:
#					return states.fall
#			elif parent._velocity.x != 0:
#				return states.run
#
#		states.jump:
#			if parent.is_on_floor():
#				return states.idle
#			elif parent._velocity.y >= 0:
#				return states.fall
#
#		states.fall:
#			if parent.is_on_floor():
#				return states.idle
#			elif parent._velocity.y < 0:
#				return states.jump
#
#		states.run:
#			if !parent.is_on_floor():
#				if parent._velocity.y < 0:
#					return states.jump
#				elif parent._velocity.y >= 0:
#					return states.fall
#			elif parent._velocity.x == 0:
#				return states.idle
#
#		states.attack:
#			# 0 - Cooled
#			# 1 - Preanimation
#			# 2 - Active
#			# 3 - PostAnimation
#			# 4 - Heated
#
#			if parent.weapon.state == 4:
#				return states.idle
#			else:
#				return states.attack
#
#		states.roll:
#			if parent.get_node("Roll").state == 4:
#				return states.fall
#			else:
#				return states.roll
#
#	return null
#
#func _enter_state(new_state, old_state):
#	match new_state:
#		states.idle:
#			parent.anim_actor.speed_scale = 1.0
#			parent.anim_actor.play("idle")
#		states.run:
#			parent.anim_actor.play("run")
#		states.fall:
#			parent.anim_actor.play("fall")
#		states.jump:
#			parent.anim_actor.play("jump")
#		states.attack:
#			parent.anim_actor.speed_scale = parent.weapon.atkspeed
#			parent.anim_actor.play("attack")
#		states.roll:
#			parent.anim_actor.play("run")
#func _exit_state(old_state, new_state):
#	pass

extends ActionStateMachine

var direction = Vector2.RIGHT
var initialPosition = Vector2.ZERO

func start():
	initialPosition = parent.get_position()
	direction = parent.lastDirection
	state = states.active
	#desactive hitbox
	
func _state_logic(delta):
	match state:
		states.active:			
			parent._direction = direction
			parent._speedModifier = Vector2(parent.speed.x * 10.0, 0)
			parent._setHit(direction)
			parent._apply_gravity(delta)
			parent._apply_movement()
	
func _get_transition(delta):
	match state:
		states.active:
			if initialPosition.distance_to(parent.get_position()) > 150.0 || parent.is_on_wall():
				parent._speedModifier = Vector2(0, 0)
				$Cooldown.start()
				return states.heated
			else:
				return states.active

func _on_Cooldown_timeout():
	state = states.cooled

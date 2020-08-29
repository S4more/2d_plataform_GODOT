extends StateMachine

#air attack related
var can_attack = true

func _ready():
	states_map = {
		"patrol" : $Patrol,
		"chase" : $Chase,
		"attack" : $Attack
#		"move" : $Move,
#		"attack" : $Attack,
#		"jump" : $Jump,
#		"doubleJump":$doubleJump,
#		"fall" : $Fall,
#		"roll" : $Roll,
#		"shoot": $Shoot,
		#"stagger" : $Stagger
	}

func _change_state(state_name):
	print(state_name)
	if not _active:
		return
	
	._change_state(state_name)

func _input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
		
	current_state.handle_input(event)

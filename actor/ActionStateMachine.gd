extends StateMachine
class_name ActionStateMachine

func _ready():
	add_state("cooled")
	add_state("preanimation")
	add_state("active")
	add_state("postanimation")
	add_state("heated")
	call_deferred("set_state", states.cooled)

func _state_logic(delta):
	pass

func _on_Duration_timeout():
	state = states.heated
	get_parent().get_node("Cooldown").start()

func _on_Cooldown_timeout():
	state = states.cooled

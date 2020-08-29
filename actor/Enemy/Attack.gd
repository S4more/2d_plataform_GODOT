extends State
export (String) var attack_anim = "attack"

enum local_states {COOLED, CURRENT, HEATED}
var local_state = local_states.COOLED
var max_attack_combo = 2
var cur_attack = 1

func enter():
	local_state = local_states.CURRENT
	owner.get_node("AnimatedSprite").play(attack_anim + str(cur_attack))

func _on_animation_finished():
	if local_state == local_states.CURRENT:
		if cur_attack >= max_attack_combo:
			cur_attack = 1
		elif owner.get_node("HitRange").canHit():
			cur_attack += 1
			emit_signal("finished", "attack")
			return
		emit_signal("finished", "chase")
		local_state = local_states.COOLED

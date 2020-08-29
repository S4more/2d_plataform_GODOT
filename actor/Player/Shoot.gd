extends State

func enter():
	owner.attackCount += 1

func update(delta):
	pass

func _on_BowShoot_attack_finished():
	emit_signal("finished", "idle")

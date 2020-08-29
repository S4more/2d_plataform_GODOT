extends Area2D

signal landed
signal missed

var _is_hit_landed = false
var _active = false

func enable():
	_is_hit_landed = false
	for shape in get_children():
		shape.call_deferred("set_disabled", false)
	_active = true


func disable():
	if not _is_hit_landed:
		emit_signal("missed")
	for shape in get_children():
		shape.call_deferred("set_disabled", true)
	_active = false


func _on_area_entered(area):
	if not area.has_method("get_hurt"):
		return
	if not area.is_in_group(get_parent().team) and not area.is_invincible:
		emit_signal("landed")
		_is_hit_landed = true

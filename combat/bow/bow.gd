extends Weapon

var _direction = Vector2(1, 0.1)
var active = false
var state
onready var team = get_parent().team

func _ready():
	damage = 20

func attack() -> void:
	if !active:
		active = true

func setDirection(boolean):
	#$Sprite.flip_h = boolean
	_direction.x = -1 if boolean else 1

func shoot():
	$Cooldown.start()
	var arrow = get_parent().arrow.instance()
	arrow.fire(_direction)
	get_parent().add_child(arrow)
	arrow.set_as_toplevel(true)
	arrow.position = get_node("../Position2D").get_global_position()
	damage = arrow.damage

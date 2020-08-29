extends Weapon

var _direction = Vector2(1, 0.1)
var active = false
var state

func _ready():
	self.connect("hit", get_node("../Combat"), "_on_hit")
	damage = 20

func changeDirection():
	if get_parent().get_node("AnimatedSprite").flip_h == true:
		if sign(scale.x) == 1:
			position.x *= -1
			scale.x *= -1
	else:
		if sign(scale.x) == -1:
			position.x *= -1
			scale.x *= -1

func attack() -> void:
	if !active:
		active = true

func shoot():
	$Cooldown.start()

func setDirection(boolean):
	#$Sprite.flip_h = boolean
	_direction.x = -1 if boolean else 1

func _on_hit(body):
	print("hit")
	if get_parent().name != body.name:
		emit_signal("hit", body, damage)
#	if body.name != "Player":
#		queue_free()

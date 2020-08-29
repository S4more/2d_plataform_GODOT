extends Area2D
class_name Projectile

export var damage = 15
export var speed = Vector2(100, 1)
#onready var team = get_parent().team
var _velocity = Vector2()
var direction = Vector2()

signal hit(body, damage)

func fire(playerDir: Vector2) -> void:
	_setAnimation()
	direction = playerDir

func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	self.connect("hit", get_node("../BowShoot"), "on_hit")


func _on_body_entered(body):
	if not body.has_node("Health"):
		queue_free()
#	else:
#		emit_signal("hit", "body", "20")

func _process(delta):
	_velocity.x = speed.x * direction.x * delta
	_setDirection()
	translate(_velocity)

func _setAnimation() -> void:
	$AnimatedSprite.play("shoot")
	
func _setDirection():
	$AnimatedSprite.flip_h = true if _velocity.x < 0 else false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

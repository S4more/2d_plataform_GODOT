extends Area2D
class_name Weapon

export (float) var cooldown = 0.1
export (float) var damage = 20.0
export (float) var atkspeed = 1.0
onready var parent = get_parent()

signal cooldownFinished
signal attackFinished
signal hit(body)

func _ready():
	# attack needs to be change for weapon animation
	var animFrames = parent.get_node("AnimatedSprite").get_sprite_frames().get_frame_count("attack")
	if cooldown < (animFrames / 60.0 / atkspeed):
		cooldown = animFrames / 60.0 / atkspeed + (animFrames / 60.0 / atkspeed) / 2.0
	$Cooldown.set_wait_time(cooldown)
	
func attack() -> void:
	$Duration.start()
	$CollisionShape2D.set_disabled(false)
	
func setDirection(boolean):
	$Sprite.flip_h = boolean
	
	
func _on_sword_body_entered(body):
	if body.name in "Enemy":
		emit_signal("hit", body)


func _on_Duration_timeout():
	emit_signal("attackFinished")
	#_isAttacking = false
	$CollisionShape2D.set_disabled(true)
	$Cooldown.start()

func _on_Cooldown_timeout():
	emit_signal("cooldownFinished")

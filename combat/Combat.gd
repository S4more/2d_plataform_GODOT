extends Node

onready var floaty_text = preload("res://utils/FloatingText.tscn")

func _ready():
	pass
	

func attack(body, damage):
	body.health.current -= get_parent().weapon.damage
	showHit(body, get_parent().weapon.damage)

func showHit(body, damage):
	var text = floaty_text.instance()
	
	text.position = body.get_global_position()
	text.position.y -= body.get_node("CollisionShape2D").shape.extents.y * 1.5
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(1.0, 1.0, 1.0)
	
	text.text = damage
	
	add_child(text)
	
func _on_hit(body, damage):
	attack(body, damage)

extends RigidBody2D

onready var HUD = preload("res://inventory/ItemHUD.tscn").instance()
onready var MASK = preload("res://inventory/HUDMask.tscn").instance()

var amount
var id

func _ready():
	get_parent().add_child(HUD)
	get_node("/root/Game/InterfaceLayer").add_child(MASK)
	HUD.init(self)
	MASK.init(HUD)
	
	
func init(curItemID):
	id = curItemID
	$Sprite.texture = curItemID["texture"]
	amount = curItemID["amount"]
	

func _on_Item_body_entered(body):
	print("WOW")
	if "Player" in body.name:
		get_owner().Inventory.addItemFromID(id)


func _on_PickBox_body_entered(body):
	if "Player" in body.name:
		body.Inventory.addItemFromID(id)
		MASK.queue_free()
		HUD.queue_free()
		queue_free()
		

extends Control

export (Color, RGBA) var UNLOCKED = Color(1, 1, 1, 1)
export (Color, RGBA) var LOCKED = Color(1, 0.3, 0.3, 1)
export (Color, RGBA) var DRAGCOLOR = Color(1, 1, 1, 0)
export (Color, RGBA) var SELECTEDCOLOR = Color(0, 1, 0, 1)

var is_Selected = false
var is_Locked = false
var curItemID = null
var descriptionVisibility = false

func _ready():
	pass

func setEmptyItem():
	$Panel/Amount.text = ""

func lockItem():
	is_Locked = true
	$Panel.set_modulate(LOCKED)
	$Panel.visible = false

func unlockItem():
	is_Locked = false
	$Panel.set_modulate(UNLOCKED)
	
func setAsDrag(ItmID):
	curItemID = ItmID
	$Panel/TextureRect.texture = JsonItemDb.smartTextureLoad(ItmID)
	$Panel.set_self_modulate(DRAGCOLOR)
	syncAmount()

func removeItem(amount = null):
	if amount == null:
		curItemID = null
		$Panel/TextureRect.texture = null
		$Panel/Amount.visible = false
		unloadDescription()

	
	elif amount > 0:
		curItemID["amount"] -= amount
		syncAmount()
		return
		
func setAsSelected():
	if is_Selected: return
	is_Selected = true
	$Panel.set_modulate(SELECTEDCOLOR)

func setAsUnselected():
	if !is_Selected: return
	is_Selected = false
	$Panel.set_modulate(UNLOCKED)
	
func syncAmount():
	$Panel/Amount.text = String(curItemID["amount"])
	if curItemID["amount"] == 1:
		$Panel/Amount.visible = false
	else:
		$Panel/Amount.visible = true
	
func addItem(ItmID):
	if curItemID != null:
		curItemID["amount"] += ItmID["amount"]
		syncAmount()
		return
	curItemID = ItmID
	$Panel/TextureRect.texture = JsonItemDb.smartTextureLoad(ItmID)
	syncAmount()

func getDescription():
	if !descriptionVisibility:
		$Popup.get_node("Description").loadDescription(curItemID)
		$Popup.show()
		var pos = get_global_mouse_position() - get_local_mouse_position() - Vector2($Popup.get_size().x, 0)
		$Popup.set_global_position(pos)
		descriptionVisibility = true

func unloadDescription():
	if descriptionVisibility:
		$Popup.get_node("Description").unloadDescription()
		$Popup.hide()
		descriptionVisibility = false

func onMouseIn():
	if curItemID != null:
		setAsSelected()
		getDescription()

func onMouseOut():
	if is_Selected:
		setAsUnselected()
		unloadDescription()

	


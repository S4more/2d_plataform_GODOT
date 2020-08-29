extends Panel

onready var InvUI = get_parent().get_node("Inventory")

var originalInvItem = null

func _ready():
	get_parent().AddWindow($Title)
	visible = false
	
func assignToSplit(invItem):
	visible = true
	originalInvItem = invItem
	$invItem.setAsDrag(originalInvItem.curItemID)
	$Name.text = originalInvItem.curItemID["name"]
	$HSlider.set("max_value", int(originalInvItem.curItemID["amount"]-1))
	$HSlider.set("value", int(originalInvItem.curItemID["amount"] / 2))


func _on_LineEdit_text_changed(new_text):
	new_text = int(new_text)
	if new_text <= 0:
		new_text = 1
	if new_text > originalInvItem.curItemID["amount"]-1:
		new_text = originalInvItem.curItemID["amount"] -1
		
	$HSlider.set("value", int(new_text))
	$LineEdit.set_text(String(new_text))
	$LineEdit.caret_position = String(new_text).length()
	


func _on_CancelBtn_pressed():
	originalInvItem = null
	visible = false
	

func _on_HSlider_value_changed(value):
	$LineEdit.text = String(value)
	


func _on_SplitBtn_pressed():
	if $LineEdit.text != "0":
		InvUI.splitFrom(originalInvItem, $HSlider.get("value"))
	_on_CancelBtn_pressed()

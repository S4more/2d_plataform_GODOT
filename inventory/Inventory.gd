extends Panel

onready var SplitUI = get_parent().get_node("SplitBox")

var saver = preload("res://player/save.tscn").instance()
var EmptyInvItem = preload('res://inventory/InvItem.tscn').instance()
var EmptyPhysicItem = preload("res://inventory/Item.tscn").instance()

var selectedPopupItem = null

var dragInvItm = null
var curDragItem = null
var is_draging = false
var selectedOnDrag = null

var availableInvSpace = 12
var MaxInvSpace = 60
var mousePos = Vector2()

const ITM_STACKABLE = "stackable"
const ITM_NAME = "name"
const ITM_AMOUNT = "amount"

func _ready():
	get_parent().AddWindow($Title)
	
	#drag and drop
	dragInvItm = EmptyInvItem.duplicate()
	dragInvItm.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	
	for x in range(availableInvSpace):
		var newInvItm = EmptyInvItem.duplicate()
		newInvItm.setEmptyItem()
		
		newInvItm.get_node("Panel").connect("mouse_entered", self, "mouseIn",[newInvItm])
		newInvItm.get_node("Panel").connect("mouse_exited", self, "mouseOut",[newInvItm])
		#newInvItm.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		
		if x >= availableInvSpace:
			newInvItm.lockItem()
			
		$ScrollContainer/GridContainer.add_child(newInvItm)
#
#	addItemFromDB("Red Arrow", 10, 2)
#	addItemFromDB("Red Bow", 1)
#	addItemFromDB("Silver Sword", 3)
##
	loader()

func _input(event):	
	if SplitUI.visible: return
	if event is InputEventMouseMotion:
		mousePos = event.position
		if is_draging:
			dragInvItm.set("rect_position",mousePos - (dragInvItm.get("rect_size")/2))
			selectedOnDrag = null
			for x in $ScrollContainer/GridContainer.get_children():
				if !x.is_Locked:
					x.setAsUnselected()
					if x.get_global_rect().has_point(mousePos):
						x.setAsSelected()
						selectedOnDrag = x


	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				#If not clicking on PopUp Menu:
				if $PopupMenu.visible and not $PopupMenu.get_global_rect().has_point(mousePos):
					$PopupMenu.hide()
					selectedPopupItem = null

				#ELIF because the player can click anywhere he wnats to close it
				#if is selcting an actual item; happens only the first time
				elif  curDragItem != null and curDragItem.curItemID != null and not is_draging:
					#add to HUD canvas
					get_parent().add_child(dragInvItm)
					curDragItem.unloadDescription()
					#set dragInvItm texture to be equals of current item.
					dragInvItm.setAsDrag(curDragItem.curItemID)
					dragInvItm.set("rect_position", mousePos - (dragInvItm.get("rect_size")/2))
					is_draging = true
				
				elif is_draging:
					if selectedOnDrag != null:
						selectedOnDrag.setAsUnselected()
						selectedOnDrag = null
						is_draging = false
						curDragItem = null
						get_parent().remove_child(dragInvItm)
					
			if event.button_index == 2 && !is_draging:
				if curDragItem != null:
					if curDragItem.curItemID != null:
						showPopup(curDragItem)
		#On release:
		else:
			#if dropped at a valid slot
			if is_draging and selectedOnDrag != null:
				if selectedOnDrag.curItemID != curDragItem.curItemID:	#If not the same item
					if selectedOnDrag.curItemID == null: 				#If slot is empty
						print("Empty slot!")
						selectedOnDrag.addItem(curDragItem.curItemID)
						curDragItem.removeItem()
						itemChanged()
					
					#If slot already occupied
					else:
						if selectedOnDrag.curItemID["name"] == curDragItem.curItemID["name"]:
							# Marge them together if they are stackable
							if selectedOnDrag.curItemID["stackable"] == true:
								print("Merged!")
								selectedOnDrag.addItem(curDragItem.curItemID)
								curDragItem.removeItem()
								itemChanged()
							else:
								print("Non stackable!")
								var tmpItem1 = selectedOnDrag.curItemID
								var tmpItem2 = curDragItem.curItemID
								selectedOnDrag.removeItem()
								curDragItem.removeItem()
								selectedOnDrag.addItem(tmpItem2)
								curDragItem.addItem(tmpItem1)
								itemChanged()
						#Just swap them if they dnt have the same name
						else:
							print("swap!")
							var tmpItem1 = selectedOnDrag.curItemID
							var tmpItem2 = curDragItem.curItemID
							selectedOnDrag.removeItem()
							curDragItem.removeItem()
							selectedOnDrag.addItem(tmpItem2)
							curDragItem.addItem(tmpItem1)
							itemChanged()
				#If the same item (didn't change slots')
				else:
					print("Same slot...")
					mouseIn(curDragItem)
					is_draging = false
					selectedOnDrag = null
					curDragItem = null
					get_parent().remove_child(dragInvItm)
					
			#if dropped outside a slot
			elif is_draging and selectedOnDrag == null:
				if mousePos.x < get_global_position().x:
					var drop = EmptyPhysicItem.duplicate()
					var p = get_owner().Stage.get_node("CanvasLayer").get_node("Player").get_position()
					drop.set_global_position(p + Vector2(40, 0))
					drop.init(curDragItem.curItemID)
					get_owner().Stage.get_node("CanvasLayer").add_child(drop)
					curDragItem.removeItem()
					
					
				selectedOnDrag = null
				is_draging = false
				curDragItem = null
				get_parent().remove_child(dragInvItm)

		save()


	

func save():
	var mini_coisa = {}
	var i = 0
	for itm in $ScrollContainer/GridContainer.get_children():
		if itm.curItemID == null:
			mini_coisa[i] = [null]
			i += 1
		else:
			mini_coisa[i] = [itm.curItemID.name, itm.curItemID.amount]
			i += 1
	saver.save_game(mini_coisa)
	
func loader():
	var dic = saver.load_game()
	for item in dic:
		if dic[item][0] == null:
			pass
		else:
			addItemFromDB(dic[item][0], dic[item][1], int(item))
		

func itemChanged():
	if selectedOnDrag != null:
		selectedOnDrag.setAsUnselected()
		selectedOnDrag = null
		is_draging = false
		curDragItem = null
		get_parent().remove_child(dragInvItm)


func showPopup(invItem):
	$PopupMenu.clear()
	$PopupMenu.set("rect_size", Vector2())
	selectedPopupItem = invItem
	if invItem.curItemID["amount"] > 1:
		$PopupMenu.add_item("Split")
	$PopupMenu.add_item("Drop")
	$PopupMenu.set_global_position(mousePos)
	$PopupMenu.show()

func splitFrom(invItem, amount):
	invItem.removeItem(amount)
	var newItem = invItem.curItemID.duplicate()
	newItem["amount"] = amount
	if addItemFromID(newItem) == false:
		invItem.addItem(newItem)
	save()

func findFreeInv(itemName, slot = -1):
	if slot == -1:
		for itm in $ScrollContainer/GridContainer.get_children():
			if !itm.is_Locked:
				if itm.curItemID == null:
					return itm
				else:
					if itm.curItemID[ITM_STACKABLE] and itm.curItemID[ITM_NAME] == itemName:
						return itm
	else:
		var itm = $ScrollContainer/GridContainer.get_child(slot)
		return itm
		
		
func findFreeInvNoStack():
	for itm in $ScrollContainer/GridContainer.get_children():
		print(itm)
		if !itm.is_Locked:
			if itm.curItemID == null:
				return itm

func addItemFromID(itemID):
	var freeSpace = findFreeInv(itemID["name"])
	if freeSpace == null:
		print("There is no space for " +itemID["name"])
		return false
	freeSpace.addItem(itemID)
	save()
	return true

func addItemFromDB(itemName, amount, slot = -1):
	var itm = JsonItemDb.getItemByID(itemName)
	if itm[ITM_STACKABLE]:
		itm[ITM_AMOUNT] = amount
		var freeInvSpace = findFreeInv(itm[ITM_NAME], slot)
		if freeInvSpace == null:
			print("Full inventory")
		else:
			freeInvSpace.addItem(itm)

	else:
		for _x in range(amount):
			itm[ITM_AMOUNT] = 1
			var freeInvSpace = findFreeInv(itm[ITM_NAME], slot)
			if freeInvSpace == null:
				print("Full inventory")
			else:
				freeInvSpace.addItem(itm)
				
	save()

func mouseIn(invItem):
	if invItem.is_Locked: return
	if is_draging: return
	curDragItem = invItem
	invItem.onMouseIn()
	
func mouseOut(invItem):
	if invItem.is_Locked: return
	if is_draging: return
	curDragItem = null
	invItem.onMouseOut()


func _on_PopupMenu_index_pressed(index):
	var itm = $PopupMenu.get_item_text(index)
	if itm != null:
		match itm:
			"Split":
				SplitUI.assignToSplit(selectedPopupItem)

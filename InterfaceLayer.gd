extends CanvasLayer

var WindowList = []
var LabelOnUse = null
var MousePos = Vector2()

var is_draging = false

var start_drag_at = Vector2()
var ViewPortSize = Vector2()

func AddWindow(labelNode):
	WindowList.append(labelNode)
	labelNode.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	labelNode.connect("mouse_entered",self,"onMouseIn",[labelNode])
	labelNode.connect("mouse_exited",self,"onMouseOut",[labelNode])
	
func _input(event):
	if LabelOnUse != null:
		MousePos = event.position
		ViewPortSize = get_viewport().get_visible_rect().size
		if is_draging:
			LabelOnUse.get_parent().set("rect_position", MousePos - start_drag_at)
		if LabelOnUse.get_parent().get_rect().position.x < 0:
			LabelOnUse.get_parent().set("rect_position",Vector2(0,LabelOnUse.get_parent().get_rect().position.y))
		if LabelOnUse.get_parent().get_rect().position.y < 0:
			LabelOnUse.get_parent().set("rect_position",Vector2(LabelOnUse.get_parent().get_rect().position.x,0))
			
		if LabelOnUse.get_parent().get_rect().size.x+LabelOnUse.get_parent().get_rect().position.x > ViewPortSize.x:
			LabelOnUse.get_parent().set("rect_position",Vector2(ViewPortSize.x - LabelOnUse.get_parent().get_rect().size.x,LabelOnUse.get_parent().get_rect().position.y))
		if LabelOnUse.get_parent().get_rect().size.y+LabelOnUse.get_parent().get_rect().position.y > ViewPortSize.y:
			LabelOnUse.get_parent().set("rect_position",Vector2(LabelOnUse.get_parent().get_rect().position.x,ViewPortSize.y - LabelOnUse.get_parent().get_rect().size.y))	
	
			
		if event is InputEventMouseButton:
			if event.pressed:
				if !is_draging:
					start_drag_at = MousePos - LabelOnUse.get_parent().get("rect_position")
					is_draging  = true
			else:
				if is_draging:
					is_draging = false
	
func onMouseIn(labelNode):
	LabelOnUse = labelNode
	
func onMouseOut(labelNode):
	if labelNode == LabelOnUse:
		LabelOnUse = null

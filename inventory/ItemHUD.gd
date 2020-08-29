extends Panel

var TargetNode
var StartOffset

func _ready():
	#self.connect("mouse_entered", self, "onMouseEntered")
	set_as_toplevel(true)
	pass

func init(TargetNodek):
	self.TargetNode = TargetNodek

func _process(delta):
	
	set_position(TargetNode.get_position() - Vector2(rect_size.x / 2, rect_size.y + 15))
	pass

func mouseIn():
	print("in")

func mouseOut():
	print("out")

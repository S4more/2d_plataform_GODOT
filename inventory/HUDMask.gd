extends Panel

var maskedObject

func init(object):
	maskedObject = object
	rect_size = maskedObject.rect_size
	
func _process(delta):
	set_global_position(maskedObject.get_global_position() + Vector2(400, 510) - Global.get("currentCamera").get_camera_position())


func _on_Panel_mouse_entered():
	maskedObject.mouseIn()

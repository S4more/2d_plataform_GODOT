extends Camera2D

func _ready():
	if is_current():
		Global.set("currentCamera", self)

extends Node

var variables = {"currentCamera":null}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set(name, object):
	for variable in variables:
		if name == variable:
			variables[name] = object
		else:
			print("Global variable not set.")

func get(name):
	for variable in variables:
		if name == variable:
			return variables[name]
		else:
			print("Global variable not found.")
			return null

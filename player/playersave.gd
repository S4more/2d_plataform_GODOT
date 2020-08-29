extends Node

var path = "res://player/save1.json"

var data = {}

func _ready():
	pass
	
func load_game():
	var file = File.new()
	if path == null: return null
	if !file.file_exists(path): return null
	file.open(path, File.READ)
	var data = {}
	data = parse_json(file.get_as_text())
	file.close()
	return data
	
	
func save_game(dict):
	var file
	
	file = File.new()
	
	file.open(path, File.WRITE)
	
	file.store_line(to_json(dict))
	
	file.close()

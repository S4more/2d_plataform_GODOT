extends Node

var script_url = "res://items/item_db.json"
var workPath = "res://sprites/"

func loadData(url):
	var file = File.new()
	if url == null: return null
	if !file.file_exists(url): return null
	file.open(url,File.READ)
	var data = {}
	data = parse_json(file.get_as_text())
	file.close()
	return data

func getItemByID(itemName):
	var itemData = {}
	itemData = loadData(script_url)
	if itemData == null:
		print("Item "+itemName+" does not exists")
		return null
	itemData[itemName]["name"] = itemName
	return itemData[itemName]
	
func smartTextureLoad(ItmID):
	if ItmID["texture"] is Texture:
		return ItmID["texture"]
	else:
		ItmID["texture"] = load(workPath+ItmID["texture"])
		return ItmID["texture"]
	

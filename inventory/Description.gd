extends Panel

func _ready():
	#get_parent().get_parent().AddWindow($Title)
	pass

func loadDescription(dic):
	$Panel/TextureRect.texture = JsonItemDb.smartTextureLoad(dic)
	if dic["amount"] == 1: $Panel/Amount.visible = false
	else: $Panel/Amount.text = str(dic["amount"])
	
	$Name.text = dic["name"]
	$Description.text = dic["description"]
	$GridContainer/status.text = "type: "
	$GridContainer/value.text = dic["type"]
	
	var formatedDict = {	
		'weight: ' : dic["weight"],
		#'price' : dic["price"],
	}
	
	for status in formatedDict:
		var teste = $GridContainer/status.duplicate()
		var teste2 = $GridContainer/value.duplicate()
		teste.text = status
		teste2.text = str(formatedDict[status])
		$GridContainer.add_child(teste)
		$GridContainer.add_child(teste2)

func unloadDescription():
	for n in $GridContainer.get_children():
		if n.get_name() != "status":
			if n.get_name() != "value":
				n.queue_free()

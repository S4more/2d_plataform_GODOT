extends Node

onready var Stage = $LevelLayer/StageOne
onready var Inventory

func _ready():
	Inventory = get_node("InterfaceLayer/Inventory")
	var player_health = $LevelLayer/StageOne/CanvasLayer/Player/Health
	var healthbar = $InterfaceLayer/HealthBar
	
	#var player_stamina = $LevelLyaer/StageOne/CanvasLayer/Player/Stamina
	#var staminabar = $InterfaceLayer/StaminaBar

	player_health.connect("changed", healthbar, "set_value")
	player_health.connect("max_changed", healthbar, "set_max")
	player_health.initialize()

func _input(event):
	if Input.is_action_just_pressed("ui_inventory"):
		$InterfaceLayer/Inventory.visible = !$InterfaceLayer/Inventory.visible

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

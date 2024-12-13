extends Node3D

var game_over_condition = 0

func _ready():
	prepare_inventory()
	

func prepare_inventory():
	var canvas = $SubViewportContainer/SubViewport/UI
	var control = canvas.get_node("Control2")
	var hbox = control.get_node("HBoxContainer")


	InventoryManager.set_inventory_container(hbox)
	
	InventoryManager._initialize_slots()

func change_game_over_condition(number):
	game_over_condition += number
	if game_over_condition >= 3:
		_game_over() 

func _game_over():
	print("Game Over!")

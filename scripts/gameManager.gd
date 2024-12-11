extends Node3D

func _ready():
# Получаем ссылку на SubViewportContainer и затем на SubViewport
	var canvas = $SubViewportContainer/SubViewport/UI
	var control = canvas.get_node("Control2")
	var hbox = control.get_node("HBoxContainer")


	InventoryManager.set_inventory_container(hbox)
	
	InventoryManager._initialize_slots()
	

extends Node3D

func _ready():
	InventoryManager.set_inventory_container($SubViewportContainer/SubViewport/CanvasLayer/Control/HBoxContainer)
	InventoryManager._initialize_slots()

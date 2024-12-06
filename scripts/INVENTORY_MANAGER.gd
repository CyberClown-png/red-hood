extends Node

var MAX_SLOTS = 7
var emptySlotTexture = preload("res://11.png")

var items: Array = []
@onready var inventory: HBoxContainer = null

func add_item(item: Node):
	items.append(item)
	_update_inventory_ui()
	print("Added item:", item.name)

func remove_item_by_id(item_id: String) -> bool:
	for item in items:
		if item.name == item_id:
			items.erase(item)
			print("Removed item with id: ", item_id)
			_update_inventory_ui()
			return true
	print("Item with id not found:", item_id)
	
	return false

func has_item(item_id: String) -> bool:
	for item in items:
		if item.name == item_id:
			return true
	return false	

func _update_inventory_ui():
	for i in range(MAX_SLOTS):
		var texture_rect = inventory.get_child(i)
		if i < items.size():
			texture_rect.texture = items[i].inventory_icon  
		else:
			texture_rect.texture = emptySlotTexture  
		


func set_inventory_container(inventory_container: Node):
	inventory = inventory_container

func _initialize_slots():
	for i in range(MAX_SLOTS):
		var texture_rect = TextureRect.new()
		texture_rect.name = "slot_%d" % i
		texture_rect.texture = emptySlotTexture  
		texture_rect.expand = true
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		inventory.add_child(texture_rect)

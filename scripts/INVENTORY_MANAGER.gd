extends Node

var MAX_SLOTS = 6

var selected_item_index: int = -1

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
	for i in MAX_SLOTS:
		var texture_rect = inventory.get_child(i)
		if i < items.size():
			texture_rect.texture = items[i].inventory_icon  
		else:
			texture_rect.texture = null  
			
			texture_rect.queue_redraw()
			
		if i == selected_item_index:
			texture_rect.modulate = Color(1, 1, 0)
		else:
			texture_rect.modulate = Color(1, 1, 1)



func set_inventory_container(inventory_container: Node):
	inventory = inventory_container

func _initialize_slots():
	var i = 0
	for child in inventory.get_children():
		child.connect("gui_input", _on_slot_clicked.bind(i))
		i+=1

func _on_slot_clicked(event, slot_index):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if selected_item_index == slot_index:
				selected_item_index = -1
				print("item deselected")
			else:
				_select_item(slot_index)
				print("Selected item:", selected_item_index)
			_update_inventory_ui()



func _select_item(slot_index):
	if slot_index < items.size():
		selected_item_index = slot_index
		var selected_item = items[selected_item_index]
		_update_inventory_ui() 
	else:
		print("No item in this slot")

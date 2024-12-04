extends Node

var items: Array = []

func add_item(item: String):
	items.append(item)
	print("Added item:", item)

func remove_item_by_id(item_id: String) -> bool:
	for item in items:
		if item == item_id:
			items.erase(item)
			print("Removed item with id: ", item_id)
			return true
	print("Item with id not found:", item_id)
	return false

func has_item(item_id: String) -> bool:
	for item in items:
		if item == item_id:
			return true
	return false	

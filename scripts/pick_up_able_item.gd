extends Node3D

@export var is_pickable: bool = true
@export var interaction_text: String
@export var required_item: String

func interact():
	if is_pickable:
		print("Item picked up!", self.name)
		InventoryManager.add_item(self.name)
		queue_free()  # Убираем объект
	else:
		print(interaction_text)
		if required_item && !InventoryManager.has_item(required_item):
			print("you need a ", required_item)
		else:
			queue_free()
			InventoryManager.remove_item_by_id(required_item)

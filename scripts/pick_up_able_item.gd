extends Node3D

@export var is_pickable: bool = false

@export var interaction_text: String
@export var required_item: String

@export var inventory_icon: Texture = null 

@export var mergable: bool = false
@export var mergeItem: StaticBody3D

func interact():
	if is_pickable:
			
		print("Item picked up!", self.name)
		InventoryManager.add_item(self)
		self.visible=false
		self.collision_layer &= ~2
	else:
		print(interaction_text)
		if InventoryManager.selected_item_index != -1:
			
			if  !InventoryManager.items[InventoryManager.selected_item_index].name == required_item:
				print("you need a ", required_item)
			else:
				queue_free()
				InventoryManager.remove_item_by_id(required_item)
			

extends Node3D

@export var is_pickable: bool = true
@export var interaction_text: String = "You clicked me!"

func interact():
	if is_pickable:
		print("Item picked up!")
		queue_free()  # Убираем объект
	else:
		print(interaction_text)

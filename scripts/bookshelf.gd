extends "res://scripts/pick_up_able_item.gd"

@export var bookshelf_image: Texture2D

func interact():
	if bookshelf_image:
		show_image()
			
func show_image():
	var canvas = $"../../SubViewportContainer/SubViewport/UI"
	var bookshelf_img_control = canvas.get_node("bookshelf image")

	if bookshelf_img_control:
		bookshelf_img_control.get_child(1).texture = bookshelf_image
		bookshelf_img_control.visible = true
		print("Showing bookshelf image.")

func _input(event):
	var canvas = $"../../SubViewportContainer/SubViewport/UI"
	var bookshelf_img_control = canvas.get_node("bookshelf image")
	if event is InputEventKey and event.pressed and bookshelf_img_control.visible:
		bookshelf_img_control.visible = false
		print("Image closed by player.")
	

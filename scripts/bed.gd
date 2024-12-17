extends "res://scripts/pick_up_able_item.gd"

func _ready():
	set_process_input(true)

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		interact()

func interact():
	if GameState.current_act == 1:
		GameState.current_act = 2
		print("Act 2!")
		act_for_interaction+=1
		return
	if GameState.current_act == 1:
		GameState.current_act=3
		print("Act 3")
		act_for_interaction+=1
		return

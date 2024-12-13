extends "res://scripts/pick_up_able_item.gd"

var desicion = true

func interact():
	if is_pickable:
		if desicion:
			print("you ate food!", self.name)
			var main_script = get_parent().get_parent() 
			main_script.change_game_over_condition(1)
			queue_free()
		else:
			print("you decided ignore food ", self.name)
		

extends Node3D

@onready var camera = $"../Camera3D"
@onready var front_ray: RayCast3D = $"../frontRay"


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pick item") :
		var mouse_position = get_viewport().get_mouse_position()
		
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position)
		
		
		
		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to
		query.collision_mask = 2  
		
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)
		

		if result:
			var clicked_object = result.collider
			if clicked_object and clicked_object.has_method("interact"):
				clicked_object.interact()

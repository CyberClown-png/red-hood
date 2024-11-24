extends Node3D

var TRAVEL_TIME := 0.3

@onready var front_ray: RayCast3D = $frontRay
@onready var back_ray: RayCast3D = $backRay
@onready var camera_3d: Camera3D = $Camera3D

var tween

func _physics_process(delta: float) -> void:
	if tween!= null:
		if tween.is_running():
			return
	if Input.is_action_just_pressed("forward") and not front_ray.is_colliding():
		tween = create_tween()
		tween.tween_property(self,"transform", transform.translated(-transform.basis.z * 2), TRAVEL_TIME)
	if Input.is_action_just_pressed("back")and not back_ray.is_colliding():
		tween = create_tween()
		tween.tween_property(self,"transform", transform.translated(transform.basis.z * 2), TRAVEL_TIME)
	if Input.is_action_just_pressed("left"):
		tween = create_tween()
		tween.tween_property(self,"transform:basis", transform.basis.rotated(-transform.basis.y ,-PI/2),TRAVEL_TIME) 
	if Input.is_action_just_pressed("right"):
		tween = create_tween()
		tween.tween_property(self,"transform:basis", transform.basis.rotated(transform.basis.y ,-PI/2),TRAVEL_TIME) 

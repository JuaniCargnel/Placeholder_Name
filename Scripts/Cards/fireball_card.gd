extends Card
class_name FireballCard

@export var projectile_scene: PackedScene

func use_card(user: Node2D) -> void:
	super.use_card(user)

	if projectile_scene == null:
		push_error("Error: projectile_scene no está asignado")
		return

	var projectile = projectile_scene.instantiate()
	projectile.global_position = user.global_position

	var mouse_pos := user.get_viewport().get_camera_2d().get_global_mouse_position()
	projectile.direction = (mouse_pos - user.global_position).normalized()
	
	projectile.max_bounces = 2
	projectile.zone_radius = 80
	projectile.damage = 50
	projectile.element = "fire"
	user.get_tree().current_scene.add_child(projectile)

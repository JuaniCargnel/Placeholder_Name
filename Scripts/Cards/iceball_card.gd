extends Card
class_name IceballCard

@export var projectile_scene: PackedScene
@export var ice_zone_radius := 400
@export var ice_zone_duration := 5.0
@export var ice_damage := 8

func use_card(user: Node2D) -> void:
	super.use_card(user)

	if projectile_scene == null:
		push_error("Error: projectile_scene no está asignado")
		return

	var projectile = projectile_scene.instantiate()
	projectile.global_position = user.global_position

	var mouse_pos := user.get_viewport().get_mouse_position()
	projectile.direction = (mouse_pos - user.global_position).normalized()

	projectile.element = "ice"
	projectile.zone_radius = ice_zone_radius
	projectile.zone_duration = ice_zone_duration
	projectile.damage = ice_damage
	
	user.get_tree().current_scene.add_child(projectile)

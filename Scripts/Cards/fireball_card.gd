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

	# Obtenemos la posición global del mouse desde el viewport
	var mouse_pos := user.get_viewport().get_mouse_position()
	projectile.direction = (mouse_pos - user.global_position).normalized()

	projectile.element = "fire"

	# Aseguramos que se agregue correctamente a la escena activa
	user.get_tree().current_scene.add_child(projectile)

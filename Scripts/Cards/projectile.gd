extends Area2D

@export var speed: float = 200.0
@export var direction: Vector2
@export var element: String = "fire"
@export var max_bounces: int = 1
@export var elemental_zone_scene: PackedScene  # ← Exportamos la escena modular
@export var zone_duration: float = 3.0
@export var zone_radius: float = 32.0

var bounces_left := 1

func _ready():
	bounces_left = max_bounces

func _physics_process(delta):
	position += direction * speed * delta
	
	var viewport_size = get_viewport_rect().size
	
		# Rebote horizontal
	if (position.x < 0 or position.x > viewport_size.x) and bounces_left > 0:
		direction.x *= -1
		bounces_left -= 1

	# Rebote vertical
	if (position.y < 0 or position.y > viewport_size.y) and bounces_left > 0:
		direction.y *= -1
		bounces_left -= 1

func _on_body_entered(body):
	if body.is_in_group("enemies"):  # Si impacta con un enemigo
		spawn_elemental_zone()
		queue_free()

func _on_area_entered(area):
	# Suponiendo que choca con paredes
	if bounces_left > 0:
		if area.is_in_group("walls"):
			var wall_pos = area.global_position
			var normal = (global_position - wall_pos).normalized()
			direction = direction.bounce(normal)
			bounces_left -= 1
	else:
		spawn_elemental_zone()
		queue_free()

func spawn_elemental_zone():
	if elemental_zone_scene:
		var zone = elemental_zone_scene.instantiate()
		zone.global_position = global_position
		zone.element = element
		zone.duration = zone_duration
		zone.radius = zone_radius
		get_tree().current_scene.add_child(zone)

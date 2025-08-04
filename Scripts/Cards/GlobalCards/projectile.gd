extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 200.0
@export var direction: Vector2
@export var element: String = "fire"
@export var max_bounces: int = 1
@export var elemental_zone_scene: PackedScene
@export var zone_duration: float = 3.0
@export var zone_radius: float = 32.0
@export var damage: int = 10

var bounces_left := 1
var recently_bounced := false

func _ready():
	bounces_left = max_bounces
	
	if sprite.sprite_frames.has_animation(element):
		sprite.play(element)
	else:
		push_warning("No se encontró animación para el elemento: " + element)

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
		spawn_elemental_zone()
		queue_free()
	
	if bounces_left > 0:
		if area.is_in_group("HWalls"):
			direction.y *= -1
			bounces_left -= 1
		elif area.is_in_group("VWalls"):
			direction.x *= -1
			bounces_left -= 1
	else:
		spawn_elemental_zone()
		call_deferred("queue_free")  # ← para evitar error de flush


func spawn_elemental_zone():
	if elemental_zone_scene:
		call_deferred("_spawn_zone")

func _spawn_zone():
	var zone = elemental_zone_scene.instantiate()
	zone.global_position = global_position
	zone.element = element
	zone.duration = zone_duration
	zone.radius = zone_radius
	get_tree().current_scene.add_child(zone)

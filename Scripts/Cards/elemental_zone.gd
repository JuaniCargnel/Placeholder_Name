extends Area2D

@export var damage := 5
@export var duration := 2.0
@export var element: String = ""
@export var radius := 24.0


func _ready():
	$CollisionShape2D.shape.radius = radius
	modulate_by_element()
	await get_tree().create_timer(duration).timeout
	queue_free()

func modulate_by_element():
	match element:
		"fire":
			$CollisionShape2D.set_debug_color("ff00216b")
		"water":
			modulate = Color(0.2, 0.5, 1)
		"ice":
			modulate = Color(0.6, 0.9, 1)
		"earth":
			modulate = Color(0.4, 0.3, 0.2)

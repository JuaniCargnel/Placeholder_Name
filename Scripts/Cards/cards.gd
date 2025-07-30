extends Resource
class_name Card

@export var name: String = "Unnamed"
@export var icon: Texture
@export var cooldown: float = 1.0

var last_used := 0.0

func can_use() -> bool:
	return Time.get_ticks_msec() / 1000.0 - last_used >= cooldown

func use_card(_user: Node2D) -> void:
	last_used = Time.get_ticks_msec() / 1000.0

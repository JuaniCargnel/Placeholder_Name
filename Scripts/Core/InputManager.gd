extends Node

# Singleton: Autoload

enum Action { MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, ATTACK, DASH }

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

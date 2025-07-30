extends Node2D

@export var max_health := 100
var health := max_health

func _ready():
	health = max_health

func take_damage(amount: int) -> void:
	health -= amount
	print("Dummy recibió ", amount, " de daño. Vida restante: ", health)

	if health <= 0:
		queue_free()

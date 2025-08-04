extends Node

var available_cards: Array[Card] = []
var current_card: Card = null

func _ready():
	# Cargá todas las cartas disponibles (provisional, a mano)
	available_cards = [
		preload("res://Scripts/Cards/dotTresCards/fireballCard.tres"),
		preload("res://Scripts/Cards/dotTresCards/waterballCard.tres"),
		preload("res://Scripts/Cards/dotTresCards/earthballCard.tres"),
		preload("res://Scripts/Cards/dotTresCards/iceballCard.tres"),
	]

	choose_random_card()

func choose_random_card():
	if available_cards.is_empty():
		return
	current_card = available_cards[randi() % available_cards.size()]
	print("Carta seleccionada: ", current_card.name)

func use_current_card(user: Node2D):
	if current_card and current_card.can_use():
		current_card.use_card(user)

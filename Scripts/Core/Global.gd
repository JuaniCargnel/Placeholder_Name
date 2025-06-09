extends Node

# Singleton: Autoload

var current_room = 0
var gold = 0
var player_data = {
	"hp": 100,
	"damage": 10,
	"cdr": 1.0,
	"deck": [],
	"active_slots": [],
	"passive_slots": [],
	"stat_slots": []
}

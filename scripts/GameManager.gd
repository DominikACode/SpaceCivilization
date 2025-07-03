extends Node

var player_ship = null
var ingame_gui = null
var turn_button = null

func _ready():
	ingame_gui = get_node("/root/InGameGui")
	turn_button = ingame_gui.get_node("UI/TurnButton/Button")
	turn_button.connect("pressed", self, "_on_turn_button_pressed")

func _process(delta):
	if player_ship == null:
		var game3d = get_node("/root/Game3D")
		if game3d and game3d.has_node("PlayerShip"):
			player_ship = game3d.get_node("PlayerShip")
			print("Player ship assigned")

func _on_turn_button_pressed():
	if player_ship:
		player_ship.endTurn()
		player_ship.calculate_income()
		ingame_gui.call("update_resource_labels", player_ship.gold, player_ship.technology)
		print("Turn ended. Gold: %d, Technology: %d" % [player_ship.gold, player_ship.technology])
	else:
		print("Player ship not found yet.")

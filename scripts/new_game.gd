extends Button



func _on_Newgame_pressed() -> void:

	TransitionManager.transition_to_scene("res://scenes/game.tscn")
	
	print("New game button pressed")

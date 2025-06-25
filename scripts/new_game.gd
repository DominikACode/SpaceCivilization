extends Button




func _on_Newgame_pressed() -> void:

	TransitionManager.transition_to_scene("res://scenes/game.tscn")
	InGameGui.visible = true
	
	print("New game button pressed")

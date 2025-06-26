extends Button

<<<<<<< HEAD



func _on_Newgame_pressed() -> void:

	TransitionManager.transition_to_scene("res://scenes/game.tscn")
	InGameGui.visible = true
	
	print("New game button pressed")
=======
func _on_Newgame_pressed() -> void:
	TransitionManager.transition_to_scene("res://scenes/settings_menu.tscn")
>>>>>>> settings-menu

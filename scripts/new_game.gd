extends Button

func _on_Newgame_pressed() -> void:
	TransitionManager.transition_to_scene("res://scenes/settings_menu.tscn")

extends Button

func _on_Newgame_pressed() -> void:
	AudioController.play_button_click()
	AudioController.stop_menu_music()
	
	#await TransitionManager.play_fade_in()
	await TransitionManager.transition_to_scene("res://scenes/settings_menu.tscn")
	#TransitionManager.transition_to_scene("res://scenes/game.tscn")
	#InGameGui.visible = true
	
	print("New game button pressed")
	InGameGui.visible = true

	

extends Button

func _on_load_game_pressed() -> void:
	AudioController.play_button_click()
	
	#await TransitionManager.play_fade_in()
	await TransitionManager.transition_to_scene("res://scenes/load_menu.tscn")

	print("Load game button pressed")
	InGameGui.visible = true

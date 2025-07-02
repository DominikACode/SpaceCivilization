extends Button

func _on_Exit_pressed() -> void:
	AudioController.play_button_click()
	AudioController.stop_menu_music()
	get_tree().quit()

extends Button




func _on_Exit_pressed() -> void:
	AudioController.play_button_click()
	get_tree().quit()

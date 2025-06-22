extends Button



func _on_Newgame_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	print("New game button pressed")

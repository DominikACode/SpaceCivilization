extends Node

@onready var menu_music = $MenuMusic
@onready var button_click_sound = $Button_Click

func play_menu_music():
	menu_music.play()

func stop_menu_music():
	menu_music.stop()

func play_button_click():
	button_click_sound.play()

extends Control

@export var character_options = {
	"Explorer": "res://assets/GameSettingsMenu/JediTempleGuard.webp",
	"Diplomat": "res://assets/GameSettingsMenu/Mandalorian.webp",
	"Warrior": "res://assets/GameSettingsMenu/Warrior.png"
}

@onready var name_input = $Panel/VBoxContainer/LineEdit
@onready var character_select = $Panel/VBoxContainer/OptionButton
@onready var character_preview = $Panel/VBoxContainer/TextureRect

func _ready():
	# Populate character options
	for character in character_options.keys():
		character_select.add_item(character)
	
	character_select.item_selected.connect(_on_character_selected)
	$Panel/VBoxContainer/HBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$Panel/VBoxContainer/HBoxContainer/StartButton.pressed.connect(_on_start_pressed)

func _on_character_selected(index):
	var selected = character_select.get_item_text(index)
	var texture = load(character_options[selected])
	character_preview.texture = texture

func _on_start_pressed():
	if name_input.text.strip_edges() == "":
		name_input.placeholder_text = "Please enter a name!"
		return
	
	GameSettings.player_name = name_input.text
	GameSettings.character_type = character_select.get_item_text(character_select.selected)
	
	TransitionManager.transition_to_scene("res://scenes/game.tscn")

func _on_back_pressed():
	TransitionManager.transition_to_scene("res://scenes/main_menu.tscn")

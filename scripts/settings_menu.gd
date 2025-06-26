extends Control

@export var character_options = {
	"Explorer": "res://assets/GameSettingsMenu/JediTempleGuard.webp",
	"Diplomat": "res://assets/GameSettingsMenu/Mandalorian.webp",
	"Warrior": "res://assets/GameSettingsMenu/Warrior.png"
}

# Update these paths to match your actual scene structure
@onready var name_input = $VBoxContainer/"LineEdit (NameInput)"
@onready var character_select = $VBoxContainer/"OptionButton (CharacterSelect)"
@onready var character_preview = $"TextureRect (CharacterPreview)"
@onready var back_button = $VBoxContainer/HBoxContainer/BackButton
@onready var start_button = $VBoxContainer/HBoxContainer/StartButton

func _ready():
	# Debug print to verify node paths
	print("NameInput exists:", name_input != null)
	print("CharacterSelect exists:", character_select != null)
	print("CharacterPreview exists:", character_preview != null)
	
	# Clear and populate the OptionButton
	character_select.clear()
	for character in character_options.keys():
		character_select.add_item(character)
	
	# Connect signals
	character_select.item_selected.connect(_on_character_selected)
	back_button.pressed.connect(_on_back_pressed)
	start_button.pressed.connect(_on_start_pressed)

func _on_character_selected(index: int):
	var selected = character_select.get_item_text(index)
	var texture = load(character_options[selected])
	if texture:
		character_preview.texture = texture
	else:
		print("Error loading texture for:", selected)

func _on_start_pressed():
	if name_input.text.strip_edges() == "":
		name_input.placeholder_text = "Please enter a name!"
		return
	
	# Save settings
	GameSettings.player_name = name_input.text
	GameSettings.character_type = character_select.get_item_text(character_select.selected)
	
	TransitionManager.transition_to_scene("res://scenes/game.tscn")
	InGameGui.visible = true

func _on_back_pressed():
	TransitionManager.transition_to_scene("res://scenes/main_menu.tscn")

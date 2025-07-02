extends Control

# Random names arrays
var first_names = [
	" Ⱬ’kørr-ẞælʒûn’ɀȺґ", "Ash", "Nova", "Rex", "Zara", "Kael", "Vera", "Luna", "Thorne", "Eira", "Jax", "Empress Nyxa", "Warden Drexx", "Archon"
]
var last_names = [
	"CⱤ¥ʂȺʃⱠѶɆX Continuüm ☌", "Ϟ𝖍’ЯɛtⱤ N¥xɊᵾ’łØⱤ", "Starlight", "Ironfist", "Duskbane", "Stormwalker", "Voidrunner", "Nightshade", "Firebrand", "Skyrider", "Volaris", "Galaxis", "Ecliptorn"
]

@export var character_options = {
	"Explorer": "res://assets/GameSettingsMenu/JediTempleGuard.webp",
	"Diplomat": "res://assets/GameSettingsMenu/Mandalorian.webp",
	"Warrior": "res://assets/GameSettingsMenu/Warrior.png"
}

@onready var name_input = $VBoxContainer/"LineEdit (NameInput)"
@onready var character_select = $VBoxContainer/"OptionButton (CharacterSelect)"
@onready var character_preview = $"TextureRect (CharacterPreview)"
@onready var back_button = $VBoxContainer/HBoxContainer/BackButton
@onready var start_button = $VBoxContainer/HBoxContainer/StartButton
@onready var random_name_button = $RandomNameButton
@onready var seed_checkbox = $VBoxContainer/UseCustomSeed
@onready var seed_input = $VBoxContainer/SeedInput

signal start_game()

func _ready():
	# Call once, so random names change every time
	randomize()
	# Debug print to verify node paths
	print("NameInput exists:", name_input != null)
	print("CharacterSelect exists:", character_select != null)
	print("CharacterPreview exists:", character_preview != null)

	# Clear and populate the OptionButton
	character_select.clear()
	character_select.add_item("-- Select Character --")
	for character in character_options.keys():
		character_select.add_item(character)

	# Ensure no character is selected by default
	character_select.select(0)
	character_preview.texture = null
	
	seed_checkbox.toggled.connect(_on_seed_checkbox_toggled)
	seed_input.editable = false

	# Connect signals
	character_select.item_selected.connect(_on_character_selected)
	random_name_button.pressed.connect(random_name)

func random_name():
	AudioController.play_button_click()
	var random_first = first_names[randi() % first_names.size()]
	var random_last = last_names[randi() % last_names.size()]
	name_input.text = random_first + " " + random_last

func _on_character_selected(index: int):
	AudioController.play_button_unwrap_click()
	var selected = character_select.get_item_text(index)
	
	# Skip if placeholder selected
	if selected == "-- Select Character --":
		character_preview.texture = null
		return

	var texture = load(character_options[selected])
	if texture:
		character_preview.texture = texture
	else:
		print("Error loading texture for:", selected)

func _on_seed_checkbox_toggled(button_pressed: bool):
	seed_input.editable = button_pressed
	GameSettings.use_custom_seed = button_pressed
	if !button_pressed:
		seed_input.text = ""

func _on_start_pressed():
	AudioController.play_button_click()
	if name_input.text.strip_edges() == "":
		name_input.placeholder_text = "Please enter a name!"
		return
	if character_select.get_item_text(character_select.selected) == "-- Select Character --":
		print("Please select a character.")
		return
		
	if GameSettings.use_custom_seed and seed_input.text.is_valid_int():
		GameSettings.world_seed = seed_input.text.to_int()
	else:
		GameSettings.world_seed = randi()  # Generate random seed

	# Save settings
	GameSettings.player_name = name_input.text
	GameSettings.character_type = character_select.get_item_text(character_select.selected)
	TransitionManager.play_fade_in()
	await TransitionManager.transition_to_scene("res://scenes/game.tscn")
	await TransitionManager.play_fade_out()
	InGameGui.get_node("UI").visible = true

func _on_back_pressed():
	AudioController.play_button_click()
	TransitionManager.transition_to_scene("res://scenes/main_menu.tscn")

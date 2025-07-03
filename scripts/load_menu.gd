extends Control

@onready var save_slots_container = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var delete_button = $VBoxContainer/HBoxContainer/DeleteButton

var selected_slot = -1

func _ready():
	refresh_save_slots()
	delete_button.disabled = true
	
func refresh_save_slots():
	# Clear existing buttons
	for child in save_slots_container.get_children():
		child.queue_free()
		
	# Create new buttons
	var slots = SaveSystem.get_save_slots()
	for slot in slots:
		var button = Button.new()
		button.text = "Slot %s - %s" % [slot, SaveSystem.load_game(slot).get("timestamp", "No date")]
		button.connect("pressed", _on_slot_selected.bind(slot))
		save_slots_container.add_child(button)

func _on_slot_selected(slot: int):
	selected_slot = slot
	delete_button.disabled = false

func _on_load_pressed():
	if selected_slot != -1:
		var save_data = SaveSystem.load_game(selected_slot)
		GameSettings.world_seed = save_data["world_seed"]
		GameSettings.player_name = save_data["player_name"]
		GameSettings.character_type = save_data["character_type"]
		
		TransitionManager.transition_to_scene("res://scenes/game.tscn")
		await TransitionManager.TransitionFinished
		
		# Restore game state
		get_tree().get_root().get_node("Game/Game3D/Player").global_transform.origin = save_data["player_position"]
		get_tree().get_root().get_node("Game/Game3D/MapGenerator").load_save_data(save_data["map_data"])

func _on_delete_pressed():
	if selected_slot != -1:
		DirAccess.remove_absolute("user://saves/save_%s.save" % selected_slot)
		refresh_save_slots()
		selected_slot = -1
		delete_button.disabled = true

func _on_back_pressed():
	TransitionManager.transition_to_scene("res://scenes/main_menu.tscn")

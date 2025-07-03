extends Node

const SAVE_PATH = "user://saves/"
const SAVE_EXTENSION = ".save"

func save_game(slot: int):
	var save_tree = get_tree()
	var player = save_tree.get_first_node_in_group("player")  # Use groups instead of hard paths
	var map_gen = save_tree.get_first_node_in_group("map_generator")
	
	if not player or not map_gen:
		push_error("Critical nodes not found for saving!")
		return

	var save_data = {
		"timestamp": Time.get_datetime_string_from_system(),
		"world_seed": GameSettings.world_seed,
		"player_name": GameSettings.player_name,
		"character_type": GameSettings.character_type,
		"player_position": player.global_transform.origin,
		"map_data": map_gen.get_save_data()
	}
	
	var dir = DirAccess.open(SAVE_PATH)
	if not dir:
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	
	var file = FileAccess.open(SAVE_PATH + "save_" + str(slot) + SAVE_EXTENSION, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game(slot: int) -> Dictionary:
	var file = FileAccess.open(SAVE_PATH + "save_" + str(slot) + SAVE_EXTENSION, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		return save_data
	return {}

func get_save_slots() -> Array:
	var slots = []
	var dir = DirAccess.open(SAVE_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(SAVE_EXTENSION):
				slots.append(file_name.trim_suffix(SAVE_EXTENSION).trim_prefix("save_"))
			file_name = dir.get_next()
	return slots

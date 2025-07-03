extends Control


@onready var label = $TurnButton/PlayerNameLabel  # Update path if needed
@onready var turn_button = $TurnButton/Button  # Or $Button if it's outside Panel
@onready var Planet_tab = $MenuPanel/BuildingSlotsContainer/TabContainer
@onready var player = get_tree().get_root().get_node("Game/Game3D/Player")  # Adjust path to your player node

@onready var goldLabel : Label = $MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer/Resources/VBoxContainer/res1
@onready var scienceLabel : Label = $MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer/Resources/VBoxContainer/res2
@onready var Property_3 = $MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer/Resources/VBoxContainer/res3
@onready var Property_4 = $MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer/Resources/VBoxContainer/res4

@onready var goldIcon = $MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer/Resources/VBoxContainer2/Gold
@onready var techIcon = $MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer/Resources/VBoxContainer2/Technology

@onready var slots_grid := $MenuPanel/BuildingSlotsContainer/TabContainer/BuildingSlotGrid

###var available_buildings := ["Empty", "Factory", "Laboratory", "Turret"]
var gold_icon := preload("res://assets/ingame_ui/coin.png")
var science_icon := preload("res://assets/ingame_ui/atom.png")

var available_buildings = [
	{ "name": "Factory", "icon": preload("res://assets/ingame_ui/factory.png") },
	{ "name": "Lab", "icon": preload("res://assets/ingame_ui/chemistry.png") },
	{ "name": "Empty", "icon": preload("res://assets/ingame_ui/empty-set.png") }
]
var resized_icons = {}
var icon_size : int = 40




#when the gui is readyUI/MenuPanel/BuildingSlotsContainer/PlanetResourcesContainer



#when the gui is ready
func _ready():
	var gold_tex = preload("res://assets/ingame_ui/coin.png")
	var tech_tex = preload("res://assets/ingame_ui/atom.png")
	
	# Przeskaluj ikony (funkcja poniżej)
	var res_icon_size : int = 26 
	var target_size_properties = Vector2(res_icon_size, res_icon_size)  # rozmiar ikon docelowy
	goldIcon.texture = resize_icon(gold_tex, target_size_properties)
	techIcon.texture = resize_icon(tech_tex, target_size_properties)
	
	
	Planet_tab.set_tab_title(0, "")
	update_turn_label()
	goldLabel.text = ""
	scienceLabel.text = ""
	Property_3.text = ""
	Property_4.text = ""
	var target_size = Vector2(icon_size, icon_size)  # rozmiar ikon docelowy
	for entry in available_buildings:
		var name = entry["name"]
		var icon = entry["icon"]
		resized_icons[name] = resize_icon(icon, target_size)
	
	# the buiding slots 
func update_building_slots(star: Node3D) -> void:
	for child in slots_grid.get_children():
		child.queue_free()

	var slot_count: int = star.building_slots.size()

	for i in range(slot_count):
		# Create the main button
		var button := Button.new()
		button.text = str(star.building_slots[i] if star.building_slots[i] != null else "Empty")
		button.name = "Slot_%d" % i
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.toggle_mode = false


		# Create the PopupMenu
		var popup := PopupMenu.new()
		popup.name = "Popup"

		# Dodajemy opcje z ikonami:
		for j in range(available_buildings.size()):
			var entry = available_buildings[j]
			var resized_icon = resize_icon(entry.icon, Vector2(40, 40))  # ⬅️ zmień rozmiar tutaj
			popup.add_icon_item(resized_icon, entry.name, j)

		# Connect signals
		button.connect("pressed", Callable(self, "_on_slot_button_pressed").bind(popup))
		popup.connect("id_pressed", Callable(self, "_on_building_chosen").bind(i, star, button))

		# Add both directly to the GridContainer
		button.add_child(popup)
		slots_grid.add_child(button)
		
		
		
		
		
		
		
		
func update_income_labels(star: Node3D) -> void:
	goldLabel.text = "Gold income: %d" % star.gold
	scienceLabel.text = "Science income: %d" % star.science
	
		
func resize_icon(original: Texture2D, size: Vector2) -> Texture2D:
	var image = original.get_image()
	image.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)
	var resized = ImageTexture.create_from_image(image)
	return resized

		
		
		
		
		
		
		
func _on_slot_button_pressed(popup: PopupMenu) -> void:
	var button = popup.get_parent() as Button
	if button:
		var button_pos = button.get_global_position()
		var button_size = button.get_size()  # zamiast button.rect_size
		var popup_size = popup.get_size()
		var height = popup_size.y
		popup.position = button_pos - Vector2(-60, 145)
	popup.popup()  # pokaż menu rozwijane
	


func _on_building_chosen(id: int, slot_id: int, star: Node3D, button: Button) -> void:
	var selected_data =available_buildings[id]
	var selected_building: String = selected_data["name"]
	star.building_slots[slot_id] = selected_building if selected_building != "Empty" else null
	button.text = selected_building
	print("Slot %d → %s" % [slot_id, selected_building])

func _on_slot_pressed(slot_id: int, star: Node3D) -> void:
	print("Kliknięto slot", slot_id, "na planecie", star.planet_id)
	# Tu później zrobisz menu rozwijane z wyborem budynku
	
	
	
	
	
	
func update_tab_name(new_name: String) -> void:
	Planet_tab.set_tab_title(0, new_name)
	print("Updated tab to:", new_name)

func update_turn_label():
	#var player_name = player.get_meta("name")
	#label.text =str( "Turn: " + str(player_name))
	pass


func _on_button_pressed() -> void:
	pass

extends Control


@onready var label = $TurnButton/PlayerNameLabel  # Update path if needed
@onready var turn_button = $TurnButton/Button  # Or $Button if it's outside Panel
@onready var Planet_tab = $MenuPanel/HBoxContainer/TabContainer
@onready var player = get_tree().get_root().get_node("Game/Game3D/Player")  # Adjust path to your player node

@onready var Property_1 = $MenuPanel/HBoxContainer/TabContainer2/Resources/VBoxContainer/res1
@onready var Property_2 = $MenuPanel/HBoxContainer/TabContainer2/Resources/VBoxContainer/res2
@onready var Property_3 = $MenuPanel/HBoxContainer/TabContainer2/Resources/VBoxContainer/res3
@onready var Property_4 = $MenuPanel/HBoxContainer/TabContainer2/Resources/VBoxContainer/res4



#when the gui is ready



#when the gui is ready
func _ready():
	Planet_tab.set_tab_title(0, "")
	update_turn_label()
	Property_1.text = ""
	Property_2.text = ""
	Property_3.text = ""
	Property_4.text = ""
	
	# to be changed , dummy function for further pourpuses
	
func update_tab_name(new_name: String) -> void:
	Planet_tab.set_tab_title(0, new_name)
	print("Updated tab to:", new_name)

func update_turn_label():
	#var player_name = player.get_meta("name")
	#label.text =str( "Turn: " + str(player_name))
	pass


func _on_button_pressed() -> void:
	var player_name = "gay"
	label.text =str( "Turn: " + str(player_name))

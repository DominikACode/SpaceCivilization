extends Control


@onready var label = $Panel/PlayerNameLabel  # Update path if needed
@onready var turn_button = $Panel/Button  # Or $Button if it's outside Panel
@onready var player = get_tree().get_root().get_node("World/Player")  # Adjust path to your player node

func _ready():
	update_turn_label()
	
	
	
	# to be changed , dummy function for further pourpuses

	
	
func update_turn_label():
	var player_name = player.get_meta("name")
	label.text =str( "Turn: " + str(player_name))


func _on_button_pressed() -> void:
	var player_name = "gay"
	label.text =str( "Turn: " + str(player_name))

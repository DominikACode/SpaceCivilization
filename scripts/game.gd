extends Node3D


# Called when the node enters the scene tree for the first time.
var selected_star: Node = null

func _ready():
	# InGameGui.get_node("UI").visible = true  # lub false
	# print("Game scene loaded, UI made visible")
	if not TransitionManager.TransitionFinished.is_connected(_on_transition_finished):
		TransitionManager.TransitionFinished.connect(_on_transition_finished)
	pass
	
func select_star(star: Node):
	if selected_star and selected_star != star:
		selected_star.unselect()
	selected_star = star
	star.select()

func unselect_all():
	if selected_star:
		selected_star.unselect()
		selected_star = null
		
		
func fade_in_ui(ui_node: CanvasItem, duration := 0.5) -> void:
	ui_node.visible = true
	ui_node.modulate.a = 0.0

	var time := 0.0
	while time < duration:
		var alpha = time / duration
		ui_node.modulate.a = clamp(alpha, 0.0, 1.0)
		time += get_process_delta_time()
		await get_tree().process_frame

	ui_node.modulate.a = 1.0
func _on_transition_finished() -> void:
	print("Transition complete — initialize game here.")
	var ui = InGameGui.get_node("UI")
	await fade_in_ui(ui)

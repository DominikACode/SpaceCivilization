extends Node3D


# Called when the node enters the scene tree for the first time.
var selected_star: Node = null

func select_star(star: Node):
	if selected_star and selected_star != star:
		selected_star.unselect()
	selected_star = star
	star.select()

func unselect_all():
	if selected_star:
		selected_star.unselect()
		selected_star = null

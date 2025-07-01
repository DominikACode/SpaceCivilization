extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var rect = $CircleMask

signal TransitionFinished();

func transition_to_scene(scene_path: String):
	await play_fade_in()
	await get_tree().change_scene_to_file(scene_path)
	await play_fade_out()
	TransitionFinished.emit()
	
func play_fade_in():
	rect.visible = true
	anim.play("fade_in")
	await anim.animation_finished
	#rect.visible = false

func play_fade_out():
	rect.visible = true
	anim.play("fade_out")
	await anim.animation_finished
	rect.visible = false

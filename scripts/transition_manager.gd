extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var rect = $CircleMask


func transition_to_scene(scene_path: String):
	rect.visible = true
	anim.play("fade_in")
	await anim.animation_finished

	get_tree().change_scene_to_file(scene_path)
	

	anim.play_backwards("fade_in")
	await anim.animation_finished
	
func play_fade_in():
	rect.visible = true
	anim.play("fade_in")
	await anim.animation_finished
	rect.visible = false

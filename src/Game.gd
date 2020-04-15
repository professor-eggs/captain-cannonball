extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


#func _ready() -> void:
#	var looped_animation_names := [
#		"idle",
#		"run"
#	]
#	var pf_anim := PixelFrogAnimationImporter.new(
#		"res://assets/sprites/Crabby/",
#		looped_animation_names
#	)

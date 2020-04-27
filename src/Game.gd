extends Node2D

onready var dialogue_box : DialogBox = $Dialogbox/Dialogbox

var demo_text : Array = [
	"Are you ready kids?",
	"Aye aye Captain!"
]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _ready() -> void:
	dialogue_box.show_text(demo_text)


#func _ready() -> void:
#	var looped_animation_names := [
#		"idle",
#		"run"
#	]
#	var pf_anim := PixelFrogAnimationImporter.new(
#		"res://assets/sprites/Crabby/",
#		looped_animation_names
#	)

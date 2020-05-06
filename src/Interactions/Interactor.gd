extends Node
class_name Interactor

signal interaction_cancelled
signal interaction_completed

var interaction_type : String = "base"
var _is_cancelling_interaction : bool = false


func _ready() -> void:
	set_physics_process(false)
	connect("interaction_cancelled", self, "_on_interaction_cancelled")
	connect("interaction_completed", self, "_on_interaction_completed")


func handle_interaction(interaction : Interaction) -> void:
	if not interaction:
		return
	set_physics_process(true)
	print('set_physics_process(true)')
	_handle_interaction(interaction)


func _handle_interaction(interaction : Interaction) -> void:
	return


func _end_interaction():
	set_physics_process(false)
	print('set_physics_process(false)')
	_is_cancelling_interaction = false


func _on_interaction_completed():
	return


func _on_interaction_cancelled():
	return

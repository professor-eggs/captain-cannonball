extends Node
class_name Interactor

signal 	interaction_cancelled
signal interaction_complete

var interaction_type = "base"


func _ready() -> void:
	set_physics_process(false)
	connect("interaction_cancelled", self, "_on_interaction_cancelled")
	connect("interaction_complete", self, "_on_interaction_complete")


func handle_interaction(interaction : Interaction) -> void:
	if not interaction:
		return
	
	set_physics_process(true)
	_handle_interaction(interaction)


func _handle_interaction(interaction : Interaction) -> void:
	return


func _end_interaction():
	set_physics_process(false)


func _on_interaction_complete():
	return


func _on_interaction_cancelled():
	return

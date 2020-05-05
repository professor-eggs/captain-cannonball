extends Node
class_name Interactor

signal cancelled_interaction

var interaction_type = "base"


func handle_interaction(interaction : Interaction) -> void:
	if not interaction:
		return
	_handle_interaction(interaction)


func _handle_interaction(interaction : Interaction) -> void:
	return

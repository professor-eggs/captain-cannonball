extends Interactor
class_name DialogueInteractor

export (NodePath) var _speech_bubble : NodePath = NodePath("../BaseSpeechBubble")
export (float) var _interaction_range : float = 100

onready var speech_bubble = get_parent().get_node(_speech_bubble)


func _init() -> void:
	interaction_type = "dialogue"


func _physics_process(delta: float) -> void:
	if (
		owner.global_position.distance_to(owner._interaction_target.global_position)
		> _interaction_range
	):
		emit_signal("interaction_cancelled")
		_is_cancelling_interaction = true


func _handle_interaction(interaction : Interaction) -> void:
	var interaction_data := {
		owner.interactor_id : speech_bubble,
		interaction.owner.interactor_id : interaction.speech_bubble
	}
	
	DialogueManager.display_dialogue(
		self,
		interaction.dialogue_id,
		interaction_data,
		"interaction_cancelled"
	)
	
	DialogueManager.connect("dialogue_ended", self, "_on_DialogueManager_dialogue_ended")


func _on_DialogueManager_dialogue_ended(error : String = "dialogue completed normally"):
	DialogueManager.disconnect("dialogue_ended", self, "_on_DialogueManager_dialogue_ended")
	emit_signal("interaction_completed", interaction_type)
	_end_interaction()

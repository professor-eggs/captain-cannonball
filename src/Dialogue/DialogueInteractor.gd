extends Interactor
class_name DialogueInteractor

export (NodePath) var _speech_bubble : NodePath = NodePath("../BaseSpeechBubble")
export (float) var interaction_range : float = 100

onready var speech_bubble = get_parent().get_node(_speech_bubble)


func _init() -> void:
	interaction_type = "dialogue"


func _handle_interaction(interaction : Interaction) -> void:
	var interaction_data := {
		owner.interactor_id : speech_bubble,
		interaction.owner.interactor_id : interaction.speech_bubble
	}
	
	DialogueManager.display_dialogue(
		self,
		interaction.dialogue_id,
		interaction_data,
		"cancelled_interaction"
	)
	
	return

extends Interaction
class_name DialogueInteraction

export (int) var dialogue_id : int = -1
export (NodePath) var _speech_bubble : NodePath = NodePath("../BaseSpeechBubble")
export (String) var interaction_target : String = ""

onready var speech_bubble = get_parent().get_node(_speech_bubble)


func _init() -> void:
	interaction_type = "dialogue"

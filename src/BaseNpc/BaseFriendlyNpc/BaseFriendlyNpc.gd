extends BaseNpc
class_name BaseFriendlyNpc

export (String) var conversation_id : String = "-1"
var can_interact := true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		var player = get_target_if_visible()
		if player and can_interact:
			_interact()
			can_interact = false


func _interact():
	DialogueManager.display_dialogue(conversation_id)


func _ready() -> void:
	DialogueManager.connect("dialogue_complete", self, "_on_DialogueManager_dialogue_complete")
	DialogueManager.register_speaker(dialogue_box, "2")


func _on_DialogueManager_dialogue_complete() -> void:
	can_interact = true

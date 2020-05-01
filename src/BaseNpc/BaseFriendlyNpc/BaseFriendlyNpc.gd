extends BaseNpc
class_name BaseFriendlyNpc

export (String) var conversation_id : String = "-1"

onready var expression_icons = $ExpressionIcons

var can_interact := true


func interact():
	DialogueManager.display_conversation(conversation_id)
	hide_expression()
	can_interact = false


func _ready() -> void:
	add_to_group("interactables")
	DialogueManager.connect("dialogue_complete", self, "_on_DialogueManager_conversation_complete")
	DialogueManager.register_speaker(dialogue_box, "2")


func play_animation(state_name : String) -> void:
	var animation_name = "invalid"
	
	match state_name:
		"idle":
			animation_name = "idle"
		"roam":
			animation_name = "run"
		"spot":
			animation_name = "idle"
	
	_animation_player.play(animation_name)


func _on_DialogueManager_dialogue_complete() -> void:
	can_interact = true


func _on_detection_area_body_exited(body : Node):
	._on_detection_area_body_exited(body)
	dialogue_box.hide()
	_on_DialogueManager_dialogue_complete()


func set_expression(expression : String):
	expression_icons.show_expression("interrogation")


func hide_expression():
	expression_icons.hide_expression()


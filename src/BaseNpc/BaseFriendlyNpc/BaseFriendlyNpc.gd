extends BaseNpc
class_name BaseFriendlyNpc

export (String) var conversation_id : String = "-1"

onready var expression_icons = $ExpressionIcons

var can_interact := true


#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_select"):
#		var player = get_target_if_visible()
#		if player and can_interact:
#			_interact()
#			can_interact = false


func _interact():
	print("interact!")
	return
#	DialogueManager.display_dialogue(conversation_id)


func _ready() -> void:
	return
#	DialogueManager.connect("dialogue_complete", self, "_on_DialogueManager_dialogue_complete")
#	DialogueManager.register_speaker(dialogue_box, "2")


func play_animation(state_name : String):
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
	return
#	can_interact = true


#func _on_detection_area_body_exited(body : Node):
#	._on_detection_area_body_exited(body)
#	dialogue_box.hide()
#	_on_DialogueManager_dialogue_complete()


func set_expression(expression : String):
	expression_icons.show_expression("interrogation")


func hide_expression():
	expression_icons.hide_expression()


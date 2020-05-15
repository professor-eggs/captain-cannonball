extends BaseNpc
class_name BaseFriendlyNpc

export (String) var interactor_id : String = "-1"

onready var dialogue_box = $BaseDialogueBox

onready var expression_icons : Node2D = $ExpressionIcons
var _is_expression_locked : bool = false


func _ready() -> void:
	add_to_group("interactables")


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


func _on_detection_area_body_exited(body : Node):
	._on_detection_area_body_exited(body)


func set_expression(expression : String):
	if _is_expression_locked:
		return
	match expression:
		"interrogation":
			expression_icons.show_expression("interrogation")


func hide_expression():
	expression_icons.hide_expression()


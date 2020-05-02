extends BaseNpc
class_name BaseFriendlyNpc

export (String) var conversation_id : String = "-1"

onready var expression_icons : Node2D = $ExpressionIcons
var _is_expression_locked : bool = false

var _interaction_state : String = "can_interact"
var _interaction_target : Node2D


func _ready() -> void:
	add_to_group("interactables")


func initiate_interaction_with(interaction_target : Node2D):
	if _interaction_state == "can_interact":
		hide_expression()
		_is_expression_locked = true
		_interaction_target = interaction_target
		_interaction_state = "interacting"
		print(name, ' initiating interaction with ', interaction_target.name)


func end_interaction():
	if _interaction_state == "interacting" and _interaction_target:
		# do some cancellation
		_is_expression_locked = false
		print(name, ' ending interaction with ', _interaction_target.name)
		_interaction_target = null
		_interaction_state = "can_interact"


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


tool
extends Control
signal displayed_text

export var id : String = "" setget set_id
var appear_disappear_duration : float = 0.1


export (bool) var _typewriter_effect_enabled := true
export (float) var _typewriter_speed_msec := 40.0
export (float) var _typewriter_fast_speed_msec := 1
var _is_typewriter_temp_disabled := false
var _typewriter_current_speed_msec : float = _typewriter_speed_msec

onready var _text_label = $MarginContainer/Text
onready var _visibility_tween : Tween = $Tween
onready var _background : ColorRect = $ColorRect
onready var _progress_indicator = $ProgressIndicator


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	hide()
	DialogueManager.connect("dialogue_ended", self, "_on_DialogueManager_dialogue_ended")
	DialogueManager.connect("displayed_last_line", self, "_on_DialogueManager_displayed_last_line")
	DialogueManager.connect("auto_advance_set", self, "_on_DialogueManager_auto_advance_set")
	DialogueManager.register_dialogue_box(self)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	if event.is_action_pressed("dialogue_display_all_text"):
		_is_typewriter_temp_disabled = true
	
	if event.is_action_pressed("dialogue_speed_up", true):
		_typewriter_current_speed_msec = _typewriter_fast_speed_msec
	else:
		_typewriter_current_speed_msec = _typewriter_speed_msec


func _get_configuration_warning() -> String:
	if not Engine.editor_hint:
		return ""
	
	return "" if not id.empty() else "ID should not be empty."


func show_text(text : String):
	if Engine.editor_hint:
		return
	
	if text.empty():
		_disappear()
		_text_label.text = ""
		return
	
	if not visible:
		_appear()
	
	_text_label.text = text
	
	if _typewriter_effect_enabled:
		_is_typewriter_temp_disabled = false
		_text_label.visible_characters = 0
		
		while _text_label.visible_characters < len(text):
			if _is_typewriter_temp_disabled:
				_text_label.visible_characters = -1
				break
			
			yield(get_tree().create_timer(_typewriter_current_speed_msec/1000), "timeout")
			_text_label.visible_characters += 1
	else:
		_text_label.visible_characters = -1
	
	emit_signal("displayed_text")


func _disappear():
	if Engine.editor_hint:
		return
	
	_visibility_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, appear_disappear_duration, Tween.TRANS_SINE, Tween.EASE_IN)
	_visibility_tween.start()
	yield(_visibility_tween, "tween_completed")
	hide()


func _appear():
	if Engine.editor_hint:
		return
	
	show()
	_visibility_tween.interpolate_property(self, "modulate:a", 0.0, 1.0, appear_disappear_duration, Tween.TRANS_SINE, Tween.EASE_IN)
	_visibility_tween.start()
	yield(_visibility_tween, "tween_completed")


func _on_DialogueManager_dialogue_ended():
	if Engine.editor_hint:
		return
	
	_disappear()


func _on_DialogueManager_displayed_last_line(_has_displayed_last_line : bool):
	if Engine.editor_hint:
		return
	
	if _has_displayed_last_line:
		_progress_indicator.icon = _progress_indicator.ICONS.SQUARE
		_progress_indicator.bouncing = false
	else:
		_progress_indicator.icon = _progress_indicator.ICONS.TRIANGLE
		_progress_indicator.bouncing = true


func _on_DialogueManager_auto_advance_set(state : bool):
	if Engine.editor_hint:
		return
	
	if state:
		_progress_indicator.hide()
	else:
		_progress_indicator.show()


func set_id(value):
	id = value
	if Engine.editor_hint:
		update_configuration_warning()


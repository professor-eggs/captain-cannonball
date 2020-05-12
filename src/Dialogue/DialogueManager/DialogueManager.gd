extends Node
signal dialogue_ended
signal displayed_last_line(_has_displayed_last_line)
signal auto_advance_set(state)

var _dialogue_boxes := {}

var lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
var _dialogue_lines := [
	{ "speaker_id" : "player", "text" : lorem },
	{ "speaker_id" : "npc", "text" : "hello there" },
	{ "speaker_id" : "player", "text" : "goodbye!" }
]

var _auto_advance := false setget _set_auto_advance
var auto_advance_duration_msec = 1000
onready var _action_dialogue_advance = InputMap.get_action_list("dialogue_advance")

var _next_line_index : int = 0
var _is_ready_for_next_line := false
var _dialogue_in_progress := false


func _ready() -> void:
	# Hacky way to get around the _ready/signal race condition
	"""
	An option for getting around this issue is to tell the BaseDialogueBox
	when a line is set to auto advance and just let it deal with it.
	There is a question about efficiency as typically the auto advance will
	only be set for cutscenes where the whole dialogue will be auto advance
	and not individual lines which means the DialogueManager is better suited
	to handle it by itself. Just not sure how best to do it at the moment.
	"""
	call_deferred("_set_auto_advance", _auto_advance)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dialogue_advance"):
		if not _dialogue_in_progress:
			_display_first_line()
		else:
			if not _is_ready_for_next_line:
				return
			_display_next_line()


func register_dialogue_box(db):
	_dialogue_boxes[db.id] = db
	db.connect("displayed_text", self, "_on_dialogue_box_displayed_text")


func _display_first_line():
	_is_ready_for_next_line = true
	_next_line_index = 0
	_dialogue_in_progress = true
	_display_next_line()


func _display_next_line():
	_is_ready_for_next_line = false
	if _next_line_index >= len(_dialogue_lines):
		_end_dialogue()
		return
	
	_show_line(_next_line_index)
	
	_next_line_index += 1
	
	emit_signal("displayed_last_line", _next_line_index >= len(_dialogue_lines))


func _end_dialogue():
	_show_line(-1)
	_next_line_index = 0
	_dialogue_in_progress = false
	emit_signal("dialogue_ended")


func _show_line(line_index):
	var line_data = _dialogue_lines[line_index]
	var speaker_id = line_data.speaker_id
	var line_text = line_data.text
	
	if line_index == -1:
		line_text = ""
	
	_dialogue_boxes[speaker_id].show_text(line_text)
	for db_id in _dialogue_boxes:
		if db_id != speaker_id:
			_dialogue_boxes[db_id].show_text("")


func _on_dialogue_box_displayed_text():
	_is_ready_for_next_line = true
	
	if _auto_advance:
		# Generate a dialogue_advance event manually
		yield(get_tree().create_timer(auto_advance_duration_msec / 1000), "timeout")
		var ev = InputEventAction.new()
		ev.action = "dialogue_advance"
		ev.pressed = true
		Input.parse_input_event(ev)


func _set_auto_advance(value):
	_auto_advance = value
	emit_signal("auto_advance_set", _auto_advance)
	
	if _auto_advance:
		# Stop listening to keyboard inputs if auto advance is enabled
		InputMap.action_erase_events("dialogue_advance")
	else:
		# Resume listening to keyboard inputs if auto advance is re-enabled
		# NOT TESTED YET
		for ev in _action_dialogue_advance:
			if not InputMap.event_is_action(ev, "dialogue_advance"):
				InputMap.action_add_event("dialogue_advance", ev)

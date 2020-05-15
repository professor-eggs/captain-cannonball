extends Node
signal dialogue_ended
signal displayed_last_line(_dialogue_box_id, _has_displayed_last_line)
signal auto_advance_set(state)


var _dialogue_boxes := {}

var lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
var _dialogue_lines := []

var _sample_dialogue_lines := [
	{ "speaker_id" : "player", "text" : "hello to you!" },
	{ "speaker_id" : "npc", "text" : "hello there" },
	{ "speaker_id" : "player", "text" : "goodbye!" }
]

var _sample_dialogue = {
	"auto_advance" : false,
	"lines" : _sample_dialogue_lines
}

var _all_dialogues = {
	"1" : _sample_dialogue
}

var _auto_advance := false setget _set_auto_advance
var auto_advance_duration_msec = 1000
onready var _action_dialogue_advance = InputMap.get_action_list("dialogue_advance")

var _next_line_index : int = 0
var _dialogue_id_in_progress : String = ""

# This is set to true when all text has finished being rendered by the
# dialogue boxes
var _is_ready_to_advance_dialogue := false


func _ready() -> void:
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dialogue_advance"):
		if not _is_ready_to_advance_dialogue:
			return
		_display_next_line()


func register_dialogue_box(db):
	_dialogue_boxes[db.id] = db
	db.connect("displayed_text", self, "_on_dialogue_box_displayed_text")
	db.connect("dialogue_interrupted", self, "_on_dialogue_box_dialogue_interrupted")


func start_dialogue(id, event: InputEvent):
	var _dialogue = _all_dialogues[id]
	self._auto_advance = bool(_dialogue.auto_advance)
	_dialogue_lines = _all_dialogues[id].lines
	_dialogue_id_in_progress = id
	
	_setup_to_display_first_line()
	_unhandled_input(event)


func _setup_to_display_first_line():
	_next_line_index = 0
	_display_next_line()


func _display_next_line():
	_is_ready_to_advance_dialogue = false
	if _next_line_index >= len(_dialogue_lines):
		_end_dialogue()
		return
	
	_show_line(_next_line_index)
	var _dialogue_box_id = _dialogue_lines[_next_line_index]["speaker_id"]
	
	_next_line_index += 1
	
	emit_signal(
		"displayed_last_line",
		_dialogue_box_id,
		_next_line_index >= len(_dialogue_lines)
	)


func _end_dialogue():
	emit_signal("dialogue_ended", _dialogue_boxes)
	
	for db in _dialogue_boxes.values():
		db.disconnect("displayed_text", self, "_on_dialogue_box_displayed_text")
		db.disconnect("dialogue_interrupted", self, "_on_dialogue_box_dialogue_interrupted")
	
	# clears all dialogue boxes
	_show_line(-1)
	
	# reinitialise script variables
	_next_line_index = 0
	_is_ready_to_advance_dialogue = false
	_dialogue_id_in_progress = ""
	_dialogue_lines = []
	_dialogue_boxes = {}
	self._auto_advance = false
	set_process_unhandled_input(false)


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
	_is_ready_to_advance_dialogue = true
	
	if _auto_advance:
		# Generate a dialogue_advance event manually
		yield(get_tree().create_timer(auto_advance_duration_msec / 1000), "timeout")
		var ev = InputEventAction.new()
		ev.action = "dialogue_advance"
		ev.pressed = true
		
		_unhandled_input(ev)


func _on_dialogue_box_dialogue_interrupted():
	_end_dialogue()


func _set_auto_advance(value):
	_auto_advance = value
	emit_signal("auto_advance_set", _auto_advance)
	set_process_unhandled_input(not _auto_advance)

extends Node
signal dialogue_ended(error)

var dialogues_file_path : String = "res://src/Dialogue/test_dialogue.csv"
var _advance_dialogue_signal : String = "ui_select"
var _current_dialogue : Array
var _current_dialogue_line_index : int = -1
var _interaction_data : Dictionary


func _ready() -> void:
	set_process_unhandled_input(false)
	connect("dialogue_ended", self, "_on_dialogue_ended")


func display_dialogue(
	initiating_interactor : Interactor,
	dialogue_id : int,
	interaction_data : Dictionary,
	cancel_dialogue_signal : String = "interaction_cancelled"
	
):
	"""
	interaction_data:
		- the text_boxes participating in the conversation along with their
		interaction IDs
		- Dictionary like { interactor_id : dialogue_box }
	cancel_dialogue_signal:
		- emitted by the initiating interactor
		- ends dialogue immediately
	"""
	
	# Connect to signal that ends dialogue
	initiating_interactor.connect(
		cancel_dialogue_signal,
		self,
		"_on_initiating_interactor_interaction_cancelled"
	)
	
	_interaction_data = interaction_data
	_current_dialogue = _load_dialogue(dialogue_id)
	set_process_unhandled_input(true)
	_display_next_dialogue_line()


func _display_next_dialogue_line():
	_clear_visible_dialogue_boxes()
	_current_dialogue_line_index += 1
	if _current_dialogue_line_index < len(_current_dialogue):
		var line = _current_dialogue[_current_dialogue_line_index]
		(_interaction_data[line.speaker_id] as DialogueBox).show_text(line.phrase_text)
	else:
		emit_signal("dialogue_ended")


func _clear_visible_dialogue_boxes():
	if not _current_dialogue_line_index > 0:
		return
	var line = _current_dialogue[_current_dialogue_line_index]
	(_interaction_data[line.speaker_id] as DialogueBox).clear_text()


func _cleanup():
	_current_dialogue = []
	_current_dialogue_line_index = -1
	_interaction_data = {}


func _on_initiating_interactor_interaction_cancelled():
	for dialogue_box in _interaction_data.values():
		(dialogue_box as DialogueBox).clear_text()
	emit_signal("dialogue_ended", "dialogue cancelled by initiating Interactor")


func _on_dialogue_ended(error : String = "dialogue completed normally"):
	_cleanup()
	set_process_unhandled_input(false)
	disconnect("dialogue_ended", self, "_on_dialogue_ended")


func _load_dialogue(id : int) -> Array:
	# doesn't use id at the moment
	var conversation := []
	var file := File.new()
	file.open(dialogues_file_path, File.READ)
	var headers = file.get_csv_line()
	var line := file.get_csv_line()
	while not file.eof_reached():
		# create dict
		var line_dict := {}
		for i in len(line):
			line_dict[headers[i]] = line[i]
		conversation.append(line_dict)
		line = file.get_csv_line()
	file.close()
	return conversation


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_advance_dialogue_signal):
		_display_next_dialogue_line()
		get_tree().set_input_as_handled()

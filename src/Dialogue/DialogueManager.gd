extends Node
signal dialogue_advanced

var dialogues_file_path : String = "res://src/Dialogue/test_dialogue.csv"
var _advance_dialogue_signal : String = "ui_select"
var _is_dialogue_active : bool = false


func display_dialogue(
	initiating_interactor : Interactor,
	dialogue_id : int,
	interaction_data : Dictionary,
	cancel_dialogue_signal : String = "cancelled_interaction"
	
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
		"cancelled_interaction",
		self,
		"_on_initiating_interactor_cancelled_interaction",
		[interaction_data]
	)
	
	var _current_dialogue : Array = _load_dialogue(dialogue_id)
	
	_is_dialogue_active = true
	var line = _current_dialogue.pop_front()
	(interaction_data[line.speaker_id] as DialogueBox).show_text(line.phrase_text)
	
	
	yield(get_tree(), "idle_frame")
	yield(self, "dialogue_advanced")
	
	while len(_current_dialogue) > 0:
		if not _is_dialogue_active:
			return
		(interaction_data[line.speaker_id] as DialogueBox).clear_text()
		line = _current_dialogue.pop_front()
		(interaction_data[line.speaker_id] as DialogueBox).show_text(line.phrase_text)
		yield(get_tree(), "idle_frame")
		yield(self, "dialogue_advanced")

	# cleanup


func _on_initiating_interactor_cancelled_interaction(interaction_data : Dictionary):
	_is_dialogue_active = false
	for dialogue_box in interaction_data.values():
		(dialogue_box as DialogueBox).clear_text()


func _load_dialogue(id : int) -> Array:
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
		emit_signal("dialogue_advanced", [_is_dialogue_active])


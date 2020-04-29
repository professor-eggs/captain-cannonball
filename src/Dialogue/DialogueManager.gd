extends Node

signal dialogue_complete

export (String, FILE, "*.csv") var dialogue_file = "res://src/Dialogue/test_dialogue.csv"


var speaker_data : Dictionary = {}
var dialogue_data : Array = []


func _ready() -> void:
	dialogue_data = _csv_to_dict(dialogue_file)


func _csv_to_dict(file_name) -> Array:
	var arr = []
	var file := File.new()
	file.open(file_name, File.READ)
	var headers = file.get_csv_line()
	#conversation_id
	#speaker_id
	#phrase_id
	#phrase_text
	#character_frame
	var line = file.get_csv_line()
	
	while not file.eof_reached():
		var line_data = {}
		for i in len(line):
			line_data[headers[i]] = line[i]
		arr.append(line_data)
		line = file.get_csv_line()
	
	return arr


func _display_dialogue(_dialogue_data : Array) -> void:
	for line in _dialogue_data:
		var dialogue_box : DialogBox = speaker_data[line.speaker_id]
		dialogue_box.show_text([line.phrase_text])
		yield(dialogue_box, "finished")


func display_dialogue(conversation_id) -> void:
	var _dialogue_data := []
	for line in dialogue_data:
		if line.conversation_id == conversation_id:
			_dialogue_data.append(line)
	if len(_dialogue_data) > 0:
		_display_dialogue(_dialogue_data)
	emit_signal("dialogue_complete")


func register_speaker(speaker_dialogue_box : DialogBox, id : String) -> void:
	speaker_data[id] = speaker_dialogue_box

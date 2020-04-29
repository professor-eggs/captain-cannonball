extends Node

export (String, FILE, "*.csv") var dialogue_file = "res://src/Dialogue/test_dialogue.csv"


var speaker_data : Dictionary = {}


func _ready() -> void:
	var dialogue_data = csv_to_dict(dialogue_file)
	call_deferred("display_dialogue", dialogue_data)
#	display_dialogue(dialogue_data)


func csv_to_dict(file_name) -> Array:
	var arr = []
	var file := File.new()
	file.open(file_name, File.READ)
	var headers = file.get_csv_line()
	var line = file.get_csv_line()
	
	while not file.eof_reached():
		var line_data = {}
		for i in len(line):
			line_data[headers[i]] = line[i]
		arr.append(line_data)
		line = file.get_csv_line()
	
	return arr


func display_dialogue(dialogue_data : Array) -> void:
	for line in dialogue_data:
		var dialogue_box : DialogBox = speaker_data[line.speaker_id]
		dialogue_box.show_text([line.phrase_text])
		yield(dialogue_box, "finished")


func register_speaker(speaker_node : Node, id : String) -> void:
	speaker_data[id] = speaker_node

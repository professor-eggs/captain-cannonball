extends Control
class_name DialogueBox


onready var text_box = $DialogueText


func _ready() -> void:
	hide()


func show_text(text : String):
	text_box.text = text
	show()


func clear_text():
	hide()
	text_box.clear()

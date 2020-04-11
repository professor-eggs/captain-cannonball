extends Node
class_name AnimationParser

var _directory : Directory


func _init(
	directory : Directory
) -> void:
	
	_directory = directory


func test():
	print(_directory)

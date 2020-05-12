extends Control

enum ICONS { TRIANGLE, SQUARE }
var icon = ICONS.TRIANGLE setget set_icon
var bouncing = true setget set_bouncing

onready var _original_position := rect_global_position
onready var _bounce_targets := [
	_original_position + _bounce_displacement,
	_original_position - _bounce_displacement
]

export (Vector2) var _bounce_displacement = Vector2(0, 2)
export (float) var _bounce_cycle_duration = 0.5

var _bounce_tween : Tween


func _ready() -> void:
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
	
	_bounce_tween = Tween.new()
	add_child(_bounce_tween)
	_bounce_tween.connect("tween_all_completed", self, "_on_bounce_tween_all_completed")


func _start_bounce_tween():
	if not bouncing:
		return
	
	if _bounce_tween.is_active():
		return
	
	_bounce_tween.remove_all()
	_bounce_tween.interpolate_property(
		self,
		"rect_global_position",
		_bounce_targets[0],
		_bounce_targets[1],
		_bounce_cycle_duration,
		Tween.TRANS_SINE
	)
	_bounce_tween.start()


func _on_bounce_tween_all_completed():
	_bounce_targets.invert()
	_start_bounce_tween()


func set_icon(value):
	var previous_icon_node = get_icon_mapping(icon)
	var icon_node = get_icon_mapping(value)
	
	if not icon_node:
		return
	
	previous_icon_node.hide()
	icon_node.show()
	icon = value


func get_icon_mapping(value):
	var icon_path : NodePath = NodePath()
	match value:
		ICONS.TRIANGLE:
			icon_path = "Triangle"
		ICONS.SQUARE:
			icon_path = "Square"
	
	if icon_path == NodePath():
		return null
	
	var icon_node = get_node(icon_path)
	return icon_node


func set_bouncing(value):
	bouncing = value
	if bouncing:
		_start_bounce_tween()
	else:
		_bounce_tween.stop_all()
		rect_global_position = _original_position

tool
extends Node

onready var _owner = get_parent() as KinematicBody2D

onready var jump_action : String = "%s_jump" % _owner.name.to_lower()
onready var move_left_action : String = "%s_move_left" % _owner.name.to_lower()
onready var move_right_action : String = "%s_move_right" % _owner.name.to_lower()
onready var attack_action : String = "%s_attack" % _owner.name.to_lower()

onready var actions : Dictionary = {
	0: jump_action,
	1: move_right_action,
	2: move_left_action,
	3: attack_action
}

export var _plan : Array = [
	{
		"step_id" : 0,
		"action_id" : 2, #left
		"duration" : 2.0,
		"next_step_id" : 1,
		"timer" : null
	},
	{
		"step_id" : 1,
		"action_id" : 1, #right
		"duration" : 2.0,
		"next_step_id" : 2,
		"timer" : null
	},
	{
		"step_id" : 2,
		"action_id" : 0, #jump
		"duration" : 0.1,
		"next_step_id" : 0,
		"timer" : null
	}
] setget set_plan

var current_plan_index := 0


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	for action in actions.values():
		InputMap.add_action(action)
	
	for step in _plan:
		var timer := Timer.new()
		timer.name = "PlanTimer%d" % step["step_id"]
		timer.wait_time = step["duration"]
		timer.autostart = false
		timer.one_shot = true
		step["timer"] = timer
		add_child(timer)
		var err := timer.connect("timeout", self, "_on_current_plan_step_timer_timeout")
		print(err)
	
	_plan[current_plan_index]["timer"].start()
	_do_action(actions[_plan[current_plan_index]["action_id"]])


func _do_action(action_name : String):
	var event := InputEventAction.new()
	event.action = action_name
	event.pressed = true
	Input.parse_input_event(event)


func _stop_action(action_name : String):
	var event := InputEventAction.new()
	event.action = action_name
	event.pressed = false
	Input.parse_input_event(event)


func _on_current_plan_step_timer_timeout() -> void:
	print('from ', current_plan_index)
	_stop_action(actions[_plan[current_plan_index]["action_id"]])
	current_plan_index = _plan[current_plan_index]["next_step_id"]
	_do_action(actions[_plan[current_plan_index]["action_id"]])
	(_plan[current_plan_index]["timer"] as Timer).start()
	print('to ', current_plan_index)


func set_plan(value) -> void:
	if Engine.editor_hint:
		if value[-1] == null:
			value[-1] = {
				"step_id" : len(value),
				"action_id" : -1,
				"duration" : -1,
				"next_step_id" : -1,
				"timer" : null
			}
	_plan = value

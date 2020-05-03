extends KinematicBody2D
class_name Player

signal cannon_fired(cannon_jump_impulse)

export var cannon_node_path : NodePath

onready var cannon : Cannon = get_node(cannon_node_path) as Cannon
onready var sprite : Sprite = $Sprite as Sprite

var facing : int = 1 setget set_facing

# can_interact, interacting, cannot_interact
var _interaction_state : String = "can_interact"
var _interaction_target : Node2D
export var _interaction_range : float = 100.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_cannon"):
		if not cannon.is_cannon_ready:
			return
		var cannon_jump_impulse = -cannon.fire()
		emit_signal("cannon_fired", cannon_jump_impulse)
	
	if (
		event.is_action_pressed("ui_select")
		and _interaction_state == "can_interact"
	):
		var interactables = get_tree().get_nodes_in_group("interactables")
		var sorter = Node2dDistanceSorter.new(
			global_position,
			facing,
			_interaction_range
		)
		var foo = sorter.get_interactable_nodes_in_direction(interactables)
		if len(foo) > 0:
			_initiate_interaction_with(foo[0])


func _physics_process(delta: float) -> void:
	if _interaction_state == "interacting" and _interaction_target:
		if (
			global_position.distance_to(_interaction_target.global_position)
			> _interaction_range
		):
			_end_interaction_with()


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value


func _initiate_interaction_with(interaction_target : Node2D):
	if _interaction_state == "can_interact":
		print(name, ' initiating interaction with ', interaction_target.name)
		var interaction : Dictionary = interaction_target.initiate_interaction_with(self)
		match interaction.type:
			"conversation":
				print(interaction.conversation_id)
		
		_interaction_target = interaction_target
		
		
		_interaction_state = "interacting"
		# temp
		yield(get_tree().create_timer(5.0), "timeout")
		_end_interaction_with()


func _end_interaction_with(interaction_target : Node2D = _interaction_target):
	if _interaction_state == "interacting" and interaction_target == _interaction_target:
		# do some cancellation
		print(name, ' ending interaction with ', _interaction_target.name)
		_interaction_target.end_interaction()
		_interaction_target = null
		_interaction_state = "can_interact"


class Node2dDistanceSorter:
	var _global_position : Vector2
	var _facing : int
	var _interact_distance
	
	func _init(
		g_pos : Vector2,
		dir : int,
		interact_distance : float
	) -> void:
		_global_position = g_pos
		_facing = dir
		_interact_distance = interact_distance
	
	
	func sort_ascending(a : Node2D, b: Node2D):
		if (
			_global_position.distance_to(a.global_position)
			< _global_position.distance_to(b.global_position)
		):
			return true
		return false
	
	
	func get_interactable_nodes_in_direction(nodes : Array) -> Array:
		var arr : Array = []
		for node in nodes:
			if (
				sign(_global_position.direction_to(node.global_position).x)
				== _facing
				
				and _global_position.distance_to(node.global_position)
				< _interact_distance
			):
				arr.append(node)
		arr.sort_custom(self, "sort_ascending")
		return arr


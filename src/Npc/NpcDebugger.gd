tool
extends Node2D

export var draw_circles : Array = [] setget set_draw_circles


func _process(delta: float) -> void:
	update()


func _draw():
	for circle_info in draw_circles:
		var node : Node = get_node(circle_info["node_path"])
		var radius : float = node.get(circle_info["property_name"])
		draw_circle(Vector2.ZERO, radius, Color(1,1,1,0.1))


func set_draw_circles(arr : Array) -> void:
	if arr[-1] == null:
		arr[-1] = {
			"node_path" : NodePath(),
			"property_name" : ""
		}
	draw_circles = arr

extends Node2D


var _points: Array[Dictionary]
var _lines: Array[Dictionary]

var _point_radius := 3
var _vector_length := 24


func add_point(at: Vector2, color: Color) -> void:
	_points.append({position = at, radius = _point_radius, color = color})
	queue_redraw()


func add_line(from: Vector2, to: Vector2, color: Color) -> void:
	_lines.append({from = from, to = to, color = color})
	queue_redraw()


func add_vector(at: Vector2, direction: Vector2, weight: float, color: Color) -> void:
	var max_vector := direction * _vector_length
	add_line(at, at + Vector2.ZERO.lerp(max_vector, weight), color)


func add_path(path: Array[Vector2], color: Color) -> void:
	var previous := path.pop_front() as Vector2
	add_point(previous, color)
	for current in path:
		add_point(current, color)
		add_line(previous, current, color)
	queue_redraw()


func _draw() -> void:
	# TODO: Ensure draw order puts this on top
	for line in _lines:
		draw_line(line.from, line.to, line.color)
	for point in _points:
		draw_circle(point.position, point.radius, point.color)
	_lines.clear()
	_points.clear()

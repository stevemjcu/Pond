extends Node2D


var _point_radius := 2
var _vector_length := 24


func draw_circline(from: Vector2, to: Vector2, radius: int, color: Color) -> void:
	draw_circle(from, radius, color)
	draw_circle(to, radius, color)
	draw_line(from, to, color, radius * 2)


func draw_capsule(height: int, radius: int, color: Color) -> void:
	var span := Vector2.RIGHT * (height - radius * 2)
	draw_circline(span / -2, span / 2, radius, color)


func draw_point(at: Vector2, color: Color) -> void:
	draw_circle(at, _point_radius, color)


func draw_vector(direction: Vector2, weight: float, color: Color) -> void:
	var min := Vector2.ZERO
	var max := direction * _vector_length
	draw_line(Vector2.ZERO, min.lerp(max, weight), color)


func draw_path(path: Array[Vector2], color: Color) -> void:
	var previous := path.pop_front() as Vector2
	draw_point(previous, color)
	for current in path:
		draw_point(current, color)
		draw_line(previous, current, color)

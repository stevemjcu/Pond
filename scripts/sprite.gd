extends Node2D


func draw_circline(from: Vector2, to: Vector2, radius: int, color: Color):
	draw_circle(from, radius, color)
	draw_circle(to, radius, color)
	draw_line(from, to, color, radius * 2)


func draw_capsule(height: int, radius: int, color: Color):
	var span := Vector2.RIGHT * (height - radius * 2)
	draw_circline(span / -2, span / 2, radius, color)

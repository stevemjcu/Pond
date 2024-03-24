class_name Bevy
extends Node2D


@export var color: Color
@export var group: String

var _members: Array[Boid]
var _goal: Vector2


func add_member(boid: Boid) -> void:
	_members.append(boid)
	boid.add_to_group(group)
	boid.bevy = self


func remove_member(boid: Boid) -> void:
	_members.remove_at(_members.find(boid))
	boid.remove_from_group(group)
	boid.bevy = null


func _physics_process(delta: float) -> void:
	# TODO: Use goal to update goal-seeking vector
	position = _average_position()
	rotation = _average_rotation()
	$Sprite.queue_redraw()


func _on_sprite_draw() -> void:
	var path := [Vector2.ZERO, to_local(_goal)] as Array[Vector2]
	$Sprite.draw_path(path, Color.GREEN)


func _input(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		_goal = event.position


func _average_position() -> Vector2:
	var position := Vector2.ZERO
	for member in _members:
		position += member.position
	position /= _members.size()
	return position


func _average_rotation() -> float:
	var rotation := 0.0
	for member in _members:
		rotation += member.rotation
	rotation /= _members.size()
	return rotation

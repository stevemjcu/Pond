class_name Bevy
extends Node2D


@export var turn_rate := 4
@export var player := false

@export var color: Color
@export var group: String

var _members: Array[Boid]
var _inside_members: Array[Boid]


func add_member(boid: Boid) -> void:
	_members.append(boid)
	boid.add_to_group(group)
	boid.bevy = self


func remove_member(boid: Boid) -> void:
	_members.remove_at(_members.find(boid))
	boid.remove_from_group(group)
	boid.bevy = null


func is_inside(boid: Boid) -> bool:
	return _inside_members.has(boid)


func _physics_process(delta: float) -> void:
	_detect_members()
	var input := _handle_input()
	var delta_rotation := input.x * turn_rate * delta
	for member in _members:
		member.velocity = member.velocity.rotated(delta_rotation)
	position = _find_center()


func _detect_members() -> void:
	_inside_members.clear()
	for body: Node2D in $OwnedArea.get_overlapping_bodies():
		_inside_members.append(body)


func _handle_input() -> Vector2:
	var input := Vector2.ZERO
	if player:
		if Input.is_action_pressed("left"):
			input += Vector2.LEFT
		if Input.is_action_pressed("right"):
			input += Vector2.RIGHT
	return input


func _find_center() -> Vector2:
	var center := Vector2.ZERO
	for member in _members:
		center += member.position
	center /= _members.size()
	return center

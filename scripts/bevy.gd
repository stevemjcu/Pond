class_name Bevy
extends Node2D


@export var turn_rate := 4
@export var player := false

@export var color: Color
@export var group: String

var _members: Array[Boid]


func add_member(boid: Boid) -> void:
	_members.append(boid)
	boid.add_to_group(group)
	boid.bevy = self


func remove_member(boid: Boid) -> void:
	_members.remove_at(_members.find(boid))
	boid.remove_from_group(group)
	boid.bevy = null


func _physics_process(delta: float) -> void:
	position = _average_position()


func _average_position() -> Vector2:
	var average := Vector2.ZERO
	for member in _members:
		average += member.position
	average /= _members.size()
	return average

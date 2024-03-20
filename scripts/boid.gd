class_name Boid
extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 300
@export var margin := 100

@export var turn_factor := 700
@export var avoid_factor := 20
@export var match_factor := 2
@export var approach_factor := 2

var _color: Color
var _group: String

var _protected_neighbors: Array[Node2D]
var _visible_neighbors: Array[Node2D]


func assign(group: String, color: Color) -> void:
	remove_from_group(_group)
	add_to_group(group)
	_group = group
	_color = color


func _physics_process(delta: float) -> void:
	_detect_neighbors()
	var impulse := Vector2.ZERO
	impulse += _avoid_screen_edge()
	impulse += _avoid_neighbors()
	impulse += _match_neighbors()
	impulse += _approach_neighbors()
	velocity += impulse * delta
	rotation = velocity.normalized().angle()
	_control_speed()
	move_and_slide()


func _on_sprite_draw() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	$Sprite.draw_capsule(shape.height, shape.radius, _color)


func _detect_neighbors() -> void:
	_protected_neighbors.clear()
	for body: Node2D in $ProtectedArea.get_overlapping_bodies():
		if body.is_in_group(_group):
			_protected_neighbors.append(body)
	_visible_neighbors.clear()
	for body: Node2D in $VisibleArea.get_overlapping_bodies():
		if body.is_in_group(_group):
			_visible_neighbors.append(body)


# Turn to avoid screen edge
func _avoid_screen_edge() -> Vector2:
	var impulse := Vector2.ZERO
	var bounds = get_viewport_rect().grow(-margin)
	if !bounds.has_point(position):
		if position.x < bounds.position.x:
			impulse += Vector2.RIGHT
		if position.x > bounds.end.x:
			impulse += Vector2.LEFT
		if position.y < bounds.position.y:
			impulse += Vector2.DOWN
		if position.y > bounds.end.y:
			impulse += Vector2.UP
	return impulse * turn_factor


# Tend to move away from nearby neighbors
func _avoid_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	for neighbor in _protected_neighbors:
		impulse += position - neighbor.position
	return impulse * avoid_factor


# Tend to align with visible neighbors
func _match_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if _visible_neighbors.size() == 0:
		return impulse
	for neighbor in _visible_neighbors:
		impulse += neighbor.velocity - velocity
	return (impulse / _visible_neighbors.size()) * match_factor


# Tend to approach visible neighbors
func _approach_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if _visible_neighbors.size() == 0:
		return impulse
	for neighbor in _visible_neighbors:
		impulse += neighbor.position - position
	return (impulse / _visible_neighbors.size()) * approach_factor


func _control_speed() -> void:
	var speed := clampf(velocity.length(), min_speed, max_speed)
	velocity = velocity.normalized() * speed

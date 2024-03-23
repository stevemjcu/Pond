class_name Boid
extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 300

@export var obstacle_margin := 100
@export var bevy_margin := 200

@export var turn_factor := 700
@export var avoid_factor := 20
@export var match_factor := 2
@export var approach_factor := 2

var bevy: Bevy

var _protected_neighbors: Array[Node2D]
var _visible_neighbors: Array[Node2D]


func _physics_process(delta: float) -> void:
	_detect_neighbors()
	var impulse := Vector2.ZERO
	impulse += _avoid_screen_edge()
	impulse += _avoid_neighbors()
	impulse += _match_neighbors()
	impulse += _approach_neighbors()
	impulse += _approach_bevy()
	velocity += impulse * delta
	rotation = velocity.normalized().angle()
	_control_speed()
	move_and_slide()


func _on_sprite_draw() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	$Sprite.draw_capsule(shape.height, shape.radius, bevy.color)


func _detect_neighbors() -> void:
	_protected_neighbors.clear()
	for body: Node2D in $ProtectedArea.get_overlapping_bodies():
		if body.is_in_group(bevy.group):
			_protected_neighbors.append(body)
	_visible_neighbors.clear()
	for body: Node2D in $VisibleArea.get_overlapping_bodies():
		if body.is_in_group(bevy.group):
			_visible_neighbors.append(body)


func _control_speed() -> void:
	var speed := clampf(velocity.length(), min_speed, max_speed)
	velocity = velocity.normalized() * speed


#region Impulses

# Turn to avoid screen edge
func _avoid_screen_edge() -> Vector2:
	var impulse := Vector2.ZERO
	var bounds = get_viewport_rect().grow(-obstacle_margin)
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
	impulse /= _visible_neighbors.size()
	return impulse * match_factor


# Tend to approach visible neighbors
func _approach_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if _visible_neighbors.size() == 0:
		return impulse
	for neighbor in _visible_neighbors:
		impulse += neighbor.position - position
	impulse /= _visible_neighbors.size()
	return impulse * approach_factor


# Tend to stay close to group
func _approach_bevy() -> Vector2:
	var impulse = Vector2.ZERO
	if (bevy.position - position).length() < bevy_margin:
		return impulse
	impulse = bevy.position - position
	return impulse * approach_factor / 8

#endregion

class_name Boid
extends CharacterBody2D


@export var MIN_SPEED := 200
@export var MAX_SPEED := 300

@export var OBSTACLE_MARGIN := 100
@export var BEVY_MARGIN := 200

@export var TURN_FACTOR := 700
@export var AVOID_FACTOR := 20
@export var MATCH_FACTOR := 2
@export var APPROACH_FACTOR := 2
@export var RETURN_FACTOR := 1

var bevy: Bevy

var _protected_neighbors: Array[Node2D]
var _visible_neighbors: Array[Node2D]

var _impulse: Vector2


func _physics_process(delta: float) -> void:
	_detect_neighbors()
	_impulse = Vector2.ZERO
	_impulse += _avoid_screen_edge()
	_impulse += _avoid_neighbors()
	_impulse += _match_neighbors()
	_impulse += _approach_neighbors()
	_impulse += _approach_bevy()
	velocity += _impulse * delta
	rotation = velocity.normalized().angle()
	_control_speed()
	move_and_slide()
	queue_redraw()


#region Drawing

func _draw() -> void:
	$BodySprite.queue_redraw()
	$ShadowSprite.queue_redraw()
	$DebugSprite.queue_redraw()


func _on_body_draw() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	$BodySprite.draw_capsule(Vector2.ZERO, shape.height, shape.radius, bevy.color)


func _on_shadow_draw() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	var offset := to_local(position + Vector2.DOWN * 32)
	var color := Color(0.25, 0.25, 0.25, 1)
	$ShadowSprite.draw_capsule(offset, shape.height, shape.radius, color)


func _on_debug_draw() -> void:
	var color := Color.YELLOW if _approach_bevy().length() == 0 else Color.RED
	$DebugSprite.draw_point(Vector2.ZERO, color)
	var direction := to_local(position + _impulse.normalized())
	var weight := _impulse.length() / MAX_SPEED
	$DebugSprite.draw_vector(Vector2.ZERO, direction, weight, color)

#endregion


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
	var speed := clampf(velocity.length(), MIN_SPEED, MAX_SPEED)
	velocity = velocity.normalized() * speed


#region Impulses

# Turn to avoid screen edge
func _avoid_screen_edge() -> Vector2:
	var impulse := Vector2.ZERO
	var bounds = get_viewport_rect().grow(-OBSTACLE_MARGIN)
	if !bounds.has_point(position):
		if position.x < bounds.position.x:
			impulse += Vector2.RIGHT
		if position.x > bounds.end.x:
			impulse += Vector2.LEFT
		if position.y < bounds.position.y:
			impulse += Vector2.DOWN
		if position.y > bounds.end.y:
			impulse += Vector2.UP
	return impulse * TURN_FACTOR


# Tend to move away from nearby neighbors
func _avoid_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	for neighbor in _protected_neighbors:
		impulse += position - neighbor.position
	return impulse * AVOID_FACTOR


# Tend to align with visible neighbors
func _match_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if _visible_neighbors.size() == 0:
		return impulse
	for neighbor in _visible_neighbors:
		impulse += neighbor.velocity - velocity
	impulse /= _visible_neighbors.size()
	return impulse * MATCH_FACTOR


# Tend to approach visible neighbors
func _approach_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if _visible_neighbors.size() == 0:
		return impulse
	for neighbor in _visible_neighbors:
		impulse += neighbor.position - position
	impulse /= _visible_neighbors.size()
	return impulse * APPROACH_FACTOR


# Tend to stay close to group
func _approach_bevy() -> Vector2:
	var impulse = Vector2.ZERO
	if (bevy.position - position).length() < BEVY_MARGIN:
		return impulse
	impulse = bevy.position - position
	return impulse * RETURN_FACTOR

#endregion

class_name Boid
extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 300

# TODO: Figure out how to tweak these in debug mode
# FIXME: Why do these vary so much compared to PICO-8 version?
# Small resolution, fixed framerate, or integer truncation?
@export var turn_factor := 700
@export var avoid_factor := 20
@export var match_factor := 2
@export var approach_factor := 0.5

@export var color := Color.LIGHT_PINK
@export var margin = 100


var group := "boid"
var protected_neighbors: Array[Boid]
var visible_neighbors: Array[Boid]


#region Rules


# TODO: Consider implementing these rules:
# Avoid obstacles rather than check screen edge
# Slightly vary direction randomly
# Oscillate at higher impulses (swimming vs gliding)
# Control speed instead of clamping
# Avoid threats and vary speed accordingly


# Turn to avoid screen edge
func avoid_screen_edge() -> Vector2:
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
func avoid_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	for neighbor in protected_neighbors:
		impulse += position - neighbor.position
	return impulse * avoid_factor


# Tend to match velocities of visible neighbors
func match_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if visible_neighbors.size() == 0:
		return impulse
	for neighbor in visible_neighbors:
		impulse += neighbor.velocity - velocity
	return (impulse / visible_neighbors.size()) * match_factor


# Tend to approach visible neighbors
func approach_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	if visible_neighbors.size() == 0:
		return impulse
	for neighbor in visible_neighbors:
		impulse += neighbor.position - position
	return (impulse / visible_neighbors.size()) * approach_factor


#endregion


func _ready() -> void:
	add_to_group(group)


func detect_neighbors() -> void:
	protected_neighbors.clear()
	for body: Node2D in $ProtectedArea.get_overlapping_bodies():
		if body.is_in_group(group):
			protected_neighbors.append(body)
	visible_neighbors.clear()
	for body: Node2D in $VisibleArea.get_overlapping_bodies():
		if body.is_in_group(group):
			visible_neighbors.append(body)


func control_speed() -> void:
	var speed = clampf(velocity.length(), min_speed, max_speed)
	velocity = velocity.normalized() * speed


func _physics_process(delta: float) -> void:
	detect_neighbors()
	var impulse = Vector2.ZERO
	# TODO: Visualize impulses for debugging
	impulse += avoid_screen_edge()
	impulse += avoid_neighbors()
	impulse += match_neighbors()
	impulse += approach_neighbors()
	velocity += impulse * delta
	rotation = velocity.normalized().angle()
	control_speed()
	move_and_slide()


# TODO: Move to static class, no autoload necessary
# Or move to sub-scene encapsulating common draw functions
func draw_circline(from: Vector2, to: Vector2, radius: int, color: Color):
	draw_circle(from, radius, color)
	draw_circle(to, radius, color)
	draw_line(from, to, color, radius * 2)


func _draw() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	var span := Vector2.RIGHT * (shape.height - shape.radius * 2)
	draw_circline(span / -2, span / 2, shape.radius, color)

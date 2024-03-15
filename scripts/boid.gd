class_name Boid
extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 300

@export var turn_factor := 700
@export var avoid_factor := 20
@export var align_factor := 1.3
@export var attract_factor := 0.005

@export var color := Color.LIGHT_PINK
@export var margin = 100


#region Rules


# TODO: Implement the following rules:
# Avoid nearby walls or obstacles
# Avoid overlapping with nearby boids
# Match velocity of nearby boids
# Tend towards nearby boids

# Furthermore:
# Avoid obstacles rather than check screen edge
# Slightly vary direction randomly
# Control speed instead of clamping
# Avoid threats and vary speed accordingly


# Try to avoid screen edge
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


# Try to avoid nearby neighbors
func avoid_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	for body in $ProtectedArea.get_overlapping_bodies()  as Array[Node2D]:
		# TODO: Add is_in_group() check
		impulse += position - body.position
	return impulse * avoid_factor


# Try to match average velocity of neighbors
func match_neighbors() -> Vector2:
	var impulse := Vector2.ZERO
	var bodies := $VisibleArea.get_overlapping_bodies() as Array[Node2D]
	if bodies.size() == 0:
		return Vector2.ZERO
	for body in bodies:
		# TODO: Add is_in_group() check
		impulse += body.velocity
	return (impulse / bodies.size() - velocity) * align_factor


#endregion


func control_speed() -> void:
	var speed = clampf(velocity.length(), min_speed, max_speed)
	velocity = velocity.normalized() * speed


func _physics_process(delta: float) -> void:
	var impulse = Vector2.ZERO
	impulse += avoid_screen_edge()
	impulse += avoid_neighbors()
	impulse += match_neighbors()
	velocity += impulse * delta
	rotation = velocity.normalized().angle()
	control_speed()
	move_and_slide()


# TODO: Move to shared location
func draw_circline(from: Vector2, to: Vector2, radius: int, color: Color):
	draw_circle(from, radius, color)
	draw_circle(to, radius, color)
	draw_line(from, to, color, radius * 2)


func _draw() -> void:
	var radius := ($CollisionShape2D.shape as CircleShape2D).radius
	var span := Vector2.RIGHT * radius * 0.6
	draw_circline(span / -2, span / 2, radius, color)

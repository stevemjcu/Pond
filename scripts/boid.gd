class_name Boid
extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 300

@export var protected_radius := 20
@export var visible_radius := 64

@export var turn_factor := 2
@export var repulse_factor := 0.05
@export var align_factor := 0.05
@export var attract_factor := 0.005

@export var color := Color.LIGHT_PINK

var bounds: Rect2
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


func avoid_screen_edge() -> Vector2:
	var direction := Vector2.ZERO
	if !bounds.has_point(position):
		if position.x < bounds.position.x: direction += Vector2.RIGHT
		if position.x > bounds.end.x: direction += Vector2.LEFT
		if position.y < bounds.position.y: direction += Vector2.DOWN
		if position.y > bounds.end.y: direction += Vector2.UP
	return direction * max_speed * turn_factor


func avoid_neighbors() -> Vector2:
	# for each boid in range
		# calculate displacement vector d
		# acceleration is d * repulse_factor
	return Vector2.ZERO


#endregion


func control_speed() -> void:
	var speed = clampf(velocity.length(), min_speed, max_speed)
	velocity = velocity.normalized() * speed


func _ready() -> void:
	bounds = get_viewport_rect().grow(-margin)


func _physics_process(delta: float) -> void:
	var acceleration = Vector2.ZERO
	acceleration += avoid_screen_edge()
	acceleration += avoid_neighbors()
	velocity += acceleration * delta
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

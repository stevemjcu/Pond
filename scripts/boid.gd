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


var accel: Vector2
var drag := 0.95

var screen: Rect2
var screen_margin = 100


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
	var push := Vector2.ZERO
	if !screen.has_point(position):
		if position.x < screen.position.x: push += Vector2.RIGHT
		if position.x > screen.end.x: push += Vector2.LEFT
		if position.y < screen.position.y: push += Vector2.DOWN
		if position.y > screen.end.y: push += Vector2.UP
	return push * max_speed * turn_factor


#endregion


func control_speed() -> void:
	var speed = clampf(velocity.length(), min_speed, max_speed)
	velocity = velocity.normalized() * speed


func _ready() -> void:
	screen = get_viewport_rect().grow(-screen_margin)


func _physics_process(delta: float) -> void:
	accel = Vector2.ZERO
	accel += avoid_screen_edge()
	velocity += accel * delta
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

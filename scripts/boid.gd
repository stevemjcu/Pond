extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 400

@export var protected_radius := 20
@export var visible_radius := 64

@export var turn_factor := 0.4
@export var repulse_factor := 0.05
@export var align_factor := 0.05
@export var attract_factor := 0.005

@export var color := Color.LIGHT_PINK


# TODO: Replace with proper collision detection
var screen_scale = 0.5
var screen: Rect2


#region Rules

# TODO: Implement the following rules:
# Avoid nearby walls or obstacles
# Avoid overlapping with nearby boids
# Match velocity of nearby boids
# Tend towards nearby boids

#endregion


func _ready() -> void:
	screen = Rect2(
		get_viewport_rect().size * screen_scale,
		get_viewport_rect().size * (1 - screen_scale) / 2)


func _physics_process(delta: float) -> void:
	var acceleration := Vector2.ZERO

	# TODO: Accumulate acceleration by applying rules

	velocity += acceleration * delta
	var speed := clampf(velocity.length(), min_speed, max_speed)
	velocity = Vector2.from_angle(rotation) * speed
	move_and_slide()


# TODO: Move to shared location
func draw_circline(from: Vector2, to: Vector2, radius: int, color: Color):
	draw_circle(from, radius, color)
	draw_circle(to, radius, color)
	draw_line(from, to, color, radius * 2)


func _draw() -> void:
	var radius := ($CollisionShape2D.shape as CircleShape2D).radius
	var span := Vector2.RIGHT * radius * 0.75
	draw_circline(span / -2, span / 2, radius, color)


# IDEAS
# Random wiggle to vary direction
# Avoid threats- increase speed based on proximity/size

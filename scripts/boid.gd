extends CharacterBody2D


@export var min_speed := 200
@export var max_speed := 800

@export var protected_radius := 20
@export var visible_radius := 64

@export var turn_factor := 0.4
@export var repulse_factor := 0.05
@export var align_factor := 0.05
@export var attract_factor := 0.005


# TODO: Replace with proper collision detection
var screen_scale = 0.5
var screen: Rect2


#region Rules

# TODO: Implement the following rules:
# Turn: Avoid nearby obstacles
# Repulse: Avoid overlapping with nearby boids
# Align: Match velocity of nearby boids
# Attract: Tend towards nearby boids

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
	velocity = velocity.normalized() * speed
	move_and_slide()


# TODO: Move to shared location
func draw_circline(from: Vector2, to: Vector2, radius: int, color: Color):
	draw_circle(from, radius, color)
	draw_circle(to, radius, color)
	draw_line(from, to, color, radius * 2)


func _draw() -> void:
	var radius := ($CollisionShape.shape as CircleShape2D).radius
	var span := Vector2.RIGHT * radius * 0.75
	$Sprite.draw_circline(span / -2, span / 2, radius)


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

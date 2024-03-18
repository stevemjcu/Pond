extends CharacterBody2D


@export var acceleration := 400
@export var drag := 0.5
@export var turn_rate := 4
@export var color := Color.LIGHT_PINK


var input: Vector2


func _ready() -> void:
	add_to_group("a")


func handle_input() -> void:
	input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input += Vector2.LEFT
	if Input.is_action_pressed("right"):
		input += Vector2.RIGHT
	if Input.is_action_pressed("forward"):
		input += Vector2.DOWN


func _physics_process(delta: float) -> void:
	handle_input()
	var angular_impulse = input.x * turn_rate * delta
	var impulse = input.y * acceleration * delta
	rotation += angular_impulse
	var direction = Vector2.from_angle(rotation)
	velocity = direction * velocity.length()
	velocity += direction * impulse
	velocity *= 1 - delta * drag
	move_and_slide()


func _on_sprite_draw() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	$Sprite.draw_capsule(shape.height, shape.radius, color)

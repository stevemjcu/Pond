extends Node2D


@export var boid_scene: PackedScene


func _ready() -> void:
	for i in range(7):
		var boid := boid_scene.instantiate() as Boid
		boid.position = get_viewport_rect().get_center()
		boid.velocity = Vector2.from_angle(randf_range(0, 2 * PI))
		boid.group = "a"
		boid.color = Color.SKY_BLUE
		add_child(boid)

	for i in range(7):
		var boid := boid_scene.instantiate() as Boid
		boid.position = get_viewport_rect().get_center()
		boid.velocity = Vector2.from_angle(randf_range(0, 2 * PI))
		boid.group = "b"
		boid.color = Color.PINK
		add_child(boid)


func _process(delta: float) -> void:
	pass

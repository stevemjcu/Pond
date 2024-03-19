extends Node2D


@export var boid_scene: PackedScene


func _ready() -> void:
	for i in range(7):
		var boid := boid_scene.instantiate() as Boid
		boid.position = get_viewport_rect().get_center()
		boid.velocity = Vector2.from_angle(randf_range(0, 2 * PI))
		boid.assign("a", Color.SKY_BLUE)
		add_child(boid)

	for i in range(7):
		var boid := boid_scene.instantiate() as Boid
		boid.position = get_viewport_rect().get_center()
		boid.velocity = Vector2.from_angle(randf_range(0, 2 * PI))
		boid.assign("b", Color.LIGHT_PINK)
		add_child(boid)

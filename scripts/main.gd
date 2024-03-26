extends Node2D


@export var boid_scene: PackedScene


func _ready() -> void:
	for i in range(9):
		var boid := boid_scene.instantiate() as Boid
		boid.position = get_viewport_rect().get_center()
		boid.velocity = Vector2.from_angle(randf_range(0, 2 * PI))
		add_child(boid)

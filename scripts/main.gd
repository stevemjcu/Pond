extends Node2D


@export var bevy_scene: PackedScene
@export var boid_scene: PackedScene


func _ready() -> void:
	_instantiate_swarm("a", 7, Color.SKY_BLUE, false)


func _instantiate_swarm(group: String, count: int, color: Color, player: bool) -> void:
	var bevy := bevy_scene.instantiate() as Bevy
	bevy.group = group
	bevy.color = color
	bevy.player = player
	add_child(bevy)
	var position := get_viewport_rect().get_center()
	var velocity := Vector2.from_angle(randf_range(0, 2 * PI))
	for i in range(count):
		var boid := boid_scene.instantiate() as Boid
		boid.position = position
		boid.velocity = velocity.rotated(randf_range(0, PI / 4))
		bevy.add_member(boid)
		add_child(boid)

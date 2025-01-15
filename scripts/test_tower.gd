extends Tower

@onready var sprite_2d: Sprite2D = $Sprite2D

func attack_target(target: Node) -> void:
	super.attack_target(target)
	sprite_2d.look_at(target.global_position)

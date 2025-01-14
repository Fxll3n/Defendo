class_name Enemy
extends Unit

signal reached_end

@export var move_speed: float = 0
@export var reward_amount: float = 0
@onready var sprite: AnimatedSprite2D = $Sprite

var last_x: float = 0
var new_x: float = 0

var is_alive: bool = true

func _enter_tree() -> void:
	
	var parent = get_parent()
	if parent is PathFollow2D:
		parent.loop = false
		parent.rotates = false

func _process(delta: float) -> void:
	global_rotation = 0
	if is_alive:
		move()

func move():
	var parent = get_parent()
	
	if parent is PathFollow2D:
		parent.progress += move_speed * get_process_delta_time()
		animate()
		if parent.progress_ratio >= 1:
			emit_signal("reached_end")
			Health.decrease(damage)
			call_deferred("queue_free")

	else:
		push_warning(self, " did not initialize with expected parent of type \"PathFollow2D\".")
	

func die():
	if is_alive:
		is_alive = false
		Currency.increase(reward_amount)
		sprite.play("die")
	

func _to_string() -> String:
	return str("EnemyUnit(\"", name, "\")")

func animate():
	new_x = global_position.x
	
	if new_x < last_x:
		sprite.flip_h = true
	elif new_x > last_x:
		sprite.flip_h = false
	
	if new_x != last_x:
		sprite.play("walk")
	else:
		sprite.play("idle")
	
	last_x = new_x
	
	

func _on_sprite_animation_looped() -> void:
	if sprite.animation == "die":
		call_deferred("queue_free")

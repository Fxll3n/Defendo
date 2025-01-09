class_name Enemy
extends Unit

signal reached_end

@export var move_speed: float = 0
@export var reward_amount: float = 0

func _enter_tree() -> void:
	
	var parent = get_parent()
	if parent is PathFollow2D:
		parent.loop = false
		parent.rotates = false

func _process(delta: float) -> void:
	global_rotation = 0
	move()

func move():
	var parent = get_parent()
	if parent is PathFollow2D:
		parent.progress += move_speed * get_process_delta_time()
	else:
		push_warning(self, " did not initialize with expected parent of type \"PathFollow2D\".")
	if parent.progress_ratio >= 1.0:
		emit_signal("reached_end")
		Health.decrease(damage)
		call_deferred("queue_free")

func die():
	Currency.increase(reward_amount)
	call_deferred("queue_free")

func _to_string() -> String:
	return str("EnemyUnit(", name, ")")

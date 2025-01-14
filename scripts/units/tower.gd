class_name Tower
extends Unit

enum TARGETING {
	FIRST,
	LAST,
	CLOSE,
	STRONG,
}

enum ATK_TYPE {
	SINGLE,
	MULTIPLE,
	CHAINED,
	AOE
}

@export_subgroup("Targeting")
@export var targeting_priority: TARGETING
@export var targeting_logic: ATK_TYPE
@export_range(0, 100) var attack_cooldown: float 
@export var heals_allies: bool = false

var enemy_list: Array[Enemy] = []

var is_placed: bool = false

var current_target: Enemy

var has_attacked: bool = false

func _process(delta: float) -> void:
	if is_placed:
		enemy_list = enemy_list.filter(is_instance_valid)
		current_target = get_target()
		if current_target:
			look_at(current_target.global_position)
			if !has_attacked:
				attack_target(current_target)
				has_attacked = true
				await get_tree().create_timer(attack_cooldown).timeout
				has_attacked = false
		

func get_target() -> Enemy:
	var target: Enemy
	if enemy_list:
		target = enemy_list[0]
		var target_parent = target.get_parent()
		for enemy in enemy_list:
			var enemy_parent = enemy.get_parent()
			match targeting_priority:
				TARGETING.FIRST:
					if enemy_parent.progress_ratio > target_parent.progress_ratio:
						target = enemy
				TARGETING.LAST:
					if enemy_parent.progress_ratio < target_parent.progress_ratio:
						target = enemy
				TARGETING.CLOSE:
					if abs(enemy_parent.global_position - global_position) > abs(target_parent.global_position - global_position):
						target = enemy
				TARGETING.STRONG:
					if enemy_parent.progress_ratio > target_parent.progress_ratio:
						target = enemy
	return target

func _on_area_entered(area: Area2D):
	var parent = area.get_parent()
	if is_instance_valid(parent) and parent is Enemy:
		enemy_list.append(parent)

func _on_area_exited(area: Area2D):
	var parent = area.get_parent()
	if is_instance_valid(parent) and parent is Enemy:
		enemy_list.erase(parent)

class_name Tower
extends Unit
@export var targeting_priority: int
@export var attack_cooldown: float = 1.0
@export var heals_allies: bool = false

var enemies_in_range: Array[Node] = []
var current_target: Node = null
var attack_ready: bool = true

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	if not attack_ready or enemies_in_range.is_empty():
		return

	current_target = select_target()
	if current_target:
		attack_target(current_target)

func select_target() -> Node:
	if enemies_in_range.is_empty():
		return null

	match targeting_priority:
		0: # First
			return enemies_in_range[0]
		1: # Last
			return enemies_in_range[-1]
		2: # Closest
			enemies_in_range.sort_custom(_sort_by_distance)
			return enemies_in_range[0]
		3: # Strongest
			enemies_in_range.sort_custom(_sort_by_strength)
			return enemies_in_range[0]

	return null  # Fallback in case match fails

func attack_target(target: Node) -> void:
	if target.has_method("take_damage"):
		attack_ready = false
		target.take_damage(damage)
		await get_tree().create_timer(attack_cooldown).timeout
		attack_ready = true

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		enemies_in_range.append(area.get_parent())

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		enemies_in_range.erase(area.get_parent())

func _sort_by_distance(a: Node, b: Node) -> bool:
	return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)

func _sort_by_strength(a: Node, b: Node) -> bool:
	return a.health > b.health  # Stronger enemies should come first

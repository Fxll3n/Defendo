class_name Unit
extends Node2D

signal unit_died

@export var max_health: float = 0
@export var damage: float = 0
@export var range: float = 0
@export var texture: Texture
@export var healthbar_pos: Vector2 = Vector2(0,0)

var health_bar_theme = preload("res://healthbar_theme.tres")
var current_health: float = 10
var hbar: Node

func _enter_tree() -> void:
	current_health = max_health
	
	# Sprite
	var sprite = Sprite2D.new()
	
	# Range
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	var range_area = Area2D.new()
	
	# Healthbar
	var bar = ProgressBar.new()
	
	# Adding child nodes
	add_child(sprite)
	
	add_child(range_area)
	range_area.add_child(collision)
	
	add_child(bar)
	# Editing child nodes
	sprite.texture = texture
	
	shape.radius = range
	collision.shape = shape
	
	range_area.monitoring = true
	
	bar.max_value = max_health
	bar.value = current_health
	bar.step = 0.01
	bar.theme = health_bar_theme
	bar.set_position(healthbar_pos)
	bar.custom_minimum_size.x = abs(2*healthbar_pos.x)
	bar.custom_minimum_size.y = abs(0.1*healthbar_pos.y)
	hbar = bar
	
	# Naming
	
	sprite.name = "Sprite"
	
	range_area.name = "Range"
	
	bar.name = "HealthBar"

func attack_target(target: Node):
	if target.has_method("take_damage"):
		target.take_damage(damage)
	else:
		push_warning(target.name, " did not contain the \"take_damage\" method.")

func take_damage(dmg_amount: float):
	if dmg_amount >= current_health:
		emit_signal("unit_died")
		die()
	else:
		current_health -= dmg_amount
	update_healthbar(current_health)

func heal_damage(heal_amount: float):
	if heal_amount + current_health >= max_health:
		current_health = max_health
	else:
		current_health += heal_amount
	update_healthbar(current_health)

func die():
	await get_tree().create_timer(0.35).timeout
	queue_free()

func update_healthbar(new_health: float):
	if hbar is ProgressBar:
		var tween = create_tween()
		tween.tween_property(hbar, "value", new_health, 0.35)

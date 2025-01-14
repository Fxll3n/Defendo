class_name Unit
extends Node2D

signal unit_died

@export var max_health: float = 0
@export var damage: float = 0
@export var range: float = 0
@export var texture: Texture
@export var healthbar_pos: Vector2 = Vector2(0,0)

var current_health: float = 0
var health_bar_theme = preload("res://assets/ui/healthbar_theme.tres")
var hbar: Node

func _ready():
	spawn()
	
func spawn() -> void:
	self.connect("unit_died", _on_unit_died)
	
	current_health = max_health
	
	# Sprite
	var sprite = Sprite2D.new()
	
	# Range
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	var range_area = Area2D.new()
	
	# Healthbar
	var bar = ProgressBar.new()
	
	# Detection area
	var detection_area = Area2D.new()
	var detection_collision = CollisionShape2D.new()
	var detection_shape = CircleShape2D.new()
	
	# Adding child nodes
	add_child(sprite)
	
	add_child(range_area)
	range_area.add_child(collision)
	range_area.connect("area_entered", _on_area_entered)
	range_area.connect("area_exited", _on_area_exited)
	
	add_child(bar)
	
	add_child(detection_area)
	detection_area.add_child(detection_collision)
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
	
	# Detection
	detection_shape.radius = 10
	detection_collision.shape = detection_shape
	detection_area.monitorable = true
	detection_collision.debug_color = Color(1,0.2,0.2, 0.8)
	# Naming
	
	sprite.name = "Sprite"
	
	range_area.name = "Range"
	
	bar.name = "HealthBar"
	
	detection_area.name = "DetectionArea"

func attack_target(target: Node):
	if target.has_method("take_damage"):
		target.take_damage(damage)
	else:
		push_warning(target.name, " did not contain the \"take_damage\" method.")

func take_damage(dmg_amount: float):
	if dmg_amount >= current_health:
		current_health = 0
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
		tween.tween_property(hbar, "value", new_health, 0.15)
		
func _on_unit_died():
	pass

func _on_area_entered(area: Area2D):
	pass

func _on_area_exited(area: Area2D):
	pass

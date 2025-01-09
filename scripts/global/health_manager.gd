extends Node

signal health_changed

var _current_health: int = 0

func increase(amount: int):
	if amount > 0:
		_current_health += amount
		emit_signal("health_changed")

func decrease(amount: int):
	if amount > 0:
		_current_health -= amount
		emit_signal("health_changed")

func set_health(amount: int):
	_current_health = amount
	emit_signal("health_changed")

func get_health() -> int:
	return _current_health

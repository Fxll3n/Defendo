extends Node

var _current_health: int = 0

func increase(amount: int):
	if amount > 0:
		_current_health += amount

func decrease(amount: int):
	if amount < 0:
		_current_health -= amount

func set_currency(amount: int):
	_current_health = amount

func get_currency() -> int:
	return _current_health

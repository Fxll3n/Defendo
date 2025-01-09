extends Node

var _current_currency: float = 0

func increase(amount: float):
	if amount > 0:
		_current_currency += amount

func decrease(amount: float):
	if amount < 0:
		_current_currency -= amount

func set_currency(amount: float):
	_current_currency = amount

func get_currency() -> float:
	return _current_currency

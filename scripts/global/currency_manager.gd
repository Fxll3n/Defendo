extends Node

signal currency_changed

var _current_currency: float = 0

func increase(amount: float):
	if amount > 0:
		_current_currency += amount
		emit_signal("currency_changed")

func decrease(amount: float):
	if amount > 0:
		_current_currency -= amount
		emit_signal("currency_changed")

func set_currency(amount: float):
	_current_currency = amount
	emit_signal("currency_changed")

func get_currency() -> float:
	return _current_currency

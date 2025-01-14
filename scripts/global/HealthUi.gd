extends Control

@export var HealthLabel: Label
@export var CashLabel: Label

func _ready() -> void:
	Health.connect("health_changed", _on_health_change)
	Currency.connect("currency_changed", _on_currency_change)
	
	Health.set_health(100)
	HealthLabel.text = str("Health: ", Health.get_health())
	
	Currency.set_currency(650)
	CashLabel.text = str("Cash: ", Currency.get_currency())

func _on_health_change():
	HealthLabel.text = str("Health: ", Health.get_health())

func _on_currency_change():
	CashLabel.text = str("Cash: ", Currency.get_currency())

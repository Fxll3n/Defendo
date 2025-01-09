extends Control

func _ready() -> void:
	$Label.text = str("Cash: ", Currency.get_currency())
	Currency.connect("currency_changed", _on_change)

func _on_change():
	$Label.text = str("Cash: ", Currency.get_currency())

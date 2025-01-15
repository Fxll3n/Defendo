extends ItemList

signal tower_bought(tower: PackedScene, cost: int)

@export var towers: Array[TowerItem]

func _ready() -> void:
	var index = 0
	for tower in towers:
		if tower is TowerItem:
			add_item(tower.tower_name, tower.tower_icon)
			set_item_tooltip(index, make_tooltip_text(tower))
			index += 1

func make_tooltip_text(tower: TowerItem):
	var text = "Name: {0}\nCost: {1}\nHealth: {2}\nDamage: {3}\nRange: {4}\nHeals Allies: {5}"
	return str(text.format([tower.tower_name, tower.tower_cost, tower.tower_max_health, tower.tower_damage, tower.tower_range, tower.tower_heals_allies]))


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index >= 0 and index < towers.size():
		var tower = towers[index]
		emit_signal("tower_bought", tower.tower, tower.tower_cost)
		
			

class_name TowerManager
extends Node2D

signal tower_placed(position: Vector2)

@export var tilemap: TileMapLayer

# Current tower to be placed
var current_tower: PackedScene = null
var current_tower_cost
var taken_coords: Array[Vector2i] = []

func _ready() -> void:
	var shop = get_tree().get_first_node_in_group("Shop")
	if shop:
		shop.connect("tower_bought", _on_tower_bought)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Mouse click detected.")
		if current_tower:
			print("Current tower is selected:", current_tower)
			var world_position = tilemap.get_global_mouse_position()
			var tile_position = tilemap.local_to_map(world_position)
			print("World Position:", world_position, "Tile Position:", tile_position)
			if is_tile_placeable(tile_position):
				print("Tile is placeable.")
				place_tower(tile_position)
			else:
				print("Tile is not placeable.")
		else:
			print("No tower selected for placement.")

func place_tower(tile_position: Vector2i) -> void:
	if not current_tower:
		print("No tower selected.")
		return

	var tower_instance = current_tower.instantiate()
	if not tower_instance:
		print("Failed to instantiate tower.")
		return
		
	
	if taken_coords.has(tile_position):
		return
	
	if Currency.get_currency() < current_tower_cost:
		return
		
	Currency.decrease(current_tower_cost)
	
	taken_coords.append(tile_position)
	var world_position = tilemap.map_to_local(tile_position)
	print("Placing tower at:", world_position)
	
	tower_instance.global_position = world_position
	add_child(tower_instance)
	emit_signal("tower_placed", world_position)
	print("Tower placed successfully.")

func is_tile_placeable(tile_position: Vector2i) -> bool:
	var cell_data = tilemap.get_cell_tile_data(tile_position)
	if cell_data:
		var placeable = cell_data.get_custom_data("Placaeble")
		print("Cell Data Custom Data (Placeable):", placeable)
		return placeable

	print("No cell data at:", tile_position)
	return false


func _on_tower_bought(tower: PackedScene, cost: int) -> void:
	print("Tower bought signal received:", tower)
	current_tower = tower
	current_tower_cost = cost
	if current_tower:
		print("Current tower set successfully:", current_tower)
	else:
		print("Failed to set current tower.")

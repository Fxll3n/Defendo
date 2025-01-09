class_name WaveSpawner
extends Node

@export var waves: Array[Wave] # Array of Wave resources
@export var paths: Array[Path2D] # Paths for enemy movement

var current_wave: int = 0

func _ready() -> void:
	# Start the first wave when the scene is ready
	if waves.size() > 0:
		start_wave(current_wave)

func start_wave(index: int):
	# Check if all waves are complete
	if index >= waves.size():
		print("All waves complete!")
		return
	
	# Get the current wave and spawn its enemies
	var wave = waves[index]
	spawn_wave(wave)

func spawn_wave(wave: Wave):
	print("Starting wave ", wave.id)
	
	# Spawn entities defined in the wave
	spawn_entities(wave.enemies)
	
	# Handle wave repetition or move to the next wave
	if wave.repeat > 0:
		wave.repeat -= 1
		await get_tree().create_timer(wave.next_wave_delay).timeout
		spawn_wave(wave) # Repeat the same wave
	else:
		await get_tree().create_timer(wave.next_wave_delay).timeout
		current_wave += 1
		start_wave(current_wave) # Move to the next wave

func spawn_entities(entities: Array[PackedScene]):
	var id = 0
	# Iterate over the array of PackedScenes and spawn each one
	for entity in entities:
		spawn_entity(entity, id)
		id += 1
		await get_tree().create_timer(0.2).timeout

func spawn_entity(entity: PackedScene, entity_id: int):
	if entity:
		# Instantiate the PackedScene
		var spawned_entity = entity.instantiate()
		var path_follower = PathFollow2D.new()
		# Select a path based on the current wave index
		var path = paths[current_wave % paths.size()]
		
		# Add the entity as a child of the selected path
		
		path.add_child(path_follower)
		path_follower.add_child(spawned_entity)
		print("Spawned entity on path: ", path.name)

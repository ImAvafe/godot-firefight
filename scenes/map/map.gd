extends Node

const tree = preload("res://scenes/tree/tree.tscn")

@export var trees = []


func _ready() -> void:
	$TreesSpawners.hide()


func _process(_delta: float) -> void:
	pass


func spawn_trees():
	for pos in $TreesSpawners.get_used_cells():
		var global_pos = $TreesSpawners.map_to_local(pos)
		
		var tree_instance = tree.instantiate()
		tree_instance.position = global_pos
		$Trees.add_child(tree_instance)

		trees.append(tree_instance)


func despawn_trees():
	for tree_instance in trees:
		tree_instance.queue_free()

	trees = []


func get_trees():
	var trees2 = []

	for child in $Trees.get_children():
		trees2.append(child)

	return trees2
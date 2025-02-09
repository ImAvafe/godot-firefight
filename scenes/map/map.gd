extends Node

const tree = preload("res://scenes/tree/tree.tscn")


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


func despawn_trees():
	for tree_instance in get_trees():
		tree_instance.queue_free()


func get_trees(excluded: Area2D = null):
	var trees = []

	for child in $Trees.get_children():
		if not child.burning and not child.extinguished and (child != excluded):
			trees.append(child)

	return trees
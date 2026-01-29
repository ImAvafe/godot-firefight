extends Area2D

# Tree target
@export var target: Node2D:
	# Chase when set
	set(value):
		target = value
		chase_target()

# Speed of movement
@export var speed = 1

# Signals for external scripts
signal hit_target
signal hit_tree

# Move towards target
func chase_target():
	var tree_size = target.find_child("Sprite2D").get_rect().size
	var target_position = target.position - Vector2(0, tree_size.y)

	var tween = create_tween()

	tween.tween_property($".", "position", target_position, ((target_position - position).length() / (200 * speed)))
	tween.tween_callback(func():
		hit_target.emit(target)
	)

	tween.play()

# Runs on scene initialization
func _ready():
	area_entered.connect(func(node):
		hit_tree.emit(node)
	)

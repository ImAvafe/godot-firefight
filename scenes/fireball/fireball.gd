extends Area2D

@export var target: Node2D:
	set(value):
		target = value
		chase_target()

@export var speed = 1

signal hit_target
signal hit_tree


func _ready():
	area_entered.connect(func(node):
		hit_tree.emit(node)
	)


func _enter_tree():
	$AnimatedSprite2D.play()


func chase_target():
	var tree_size = target.find_child("Sprite2D").get_rect().size
	var target_position = target.position - Vector2(0, tree_size.y)

	var tween = create_tween()
	tween.tween_property($".", "position", target_position, ((target_position - position).length() / (200 * speed)))
	tween.tween_callback(func():
		hit_target.emit(target)
	)
	tween.play()

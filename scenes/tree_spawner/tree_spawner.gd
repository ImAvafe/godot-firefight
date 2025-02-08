extends Node2D

const tree = preload("res://scenes/tree/tree.tscn")


func _ready() -> void:
	hide()
	spawn()


func _process(_delta: float) -> void:
	pass


func spawn():
	add_child(tree.instantiate())

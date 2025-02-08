extends Node2D

@export var burning: bool:
	set(value):
		burning = value
		update_burning()


func _ready() -> void:
	burning = randi() % 3 == 2


func _process(_delta: float) -> void:
	pass


func update_burning():
	$Sprite2D/Fire.visible = burning
	
	if burning:
		$Sprite2D/Fire.play()
	else:
		$Sprite2D/Fire.stop()

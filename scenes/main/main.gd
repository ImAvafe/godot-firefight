extends Node

const fireball = preload("res://scenes/fireball/fireball.tscn")

var game_active = false
var level = 0
var fireball_instance


func _process(_delta: float):
  if Input.is_action_just_pressed("start_game"):
    if not game_active:
      start_game()


func start_game():
  game_active = true
  level = 0

  new_level()


func end_game():
  game_active = false


func new_level():
  level += 1

  $Map.despawn_trees()
  $Map.spawn_trees()

  if fireball_instance:
    fireball_instance.queue_free()

  fireball_instance = fireball.instantiate()

  fireball_instance.hit_target.connect(func():
    fireball_instance.target = $Map.get_trees().pick_random()
  )

  fireball_instance.target = $Map.get_trees().pick_random()
  
  add_child(fireball_instance)
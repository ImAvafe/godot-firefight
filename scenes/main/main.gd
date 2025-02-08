extends Node

var game_active = false
var level = 0


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
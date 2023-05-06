extends Node

var json = JSON.new()

var PlayerScene: PackedScene = preload("res://scenes/Player/Player.tscn")

var players = {
  # Contains all the player instances.
}

func _ready():
  var player_instance = PlayerScene.instantiate()

  player_instance.name = str(Networking.account.user.username)
  player_instance.name = str(Networking.account.user.username)

  players[Networking.account.user.id] = player_instance

  get_tree().current_scene.get_node("Players").add_child(player_instance, true)

  Networking.socket.received_match_state.connect(_on_received_match_state)


func _on_received_match_state(state: NakamaRTAPI.MatchData):
  match state.op_code:
    1:
      _on_received_spawn_state(state)
    2:
      _on_received_position_state(state)
    3:
      _on_received_rotation_state(state)


func _on_received_spawn_state(state: NakamaRTAPI.MatchData):
  var player_instance = PlayerScene.instantiate()

  player_instance.name = str(state.presence.username)
  player_instance.name = str(state.presence.username)

  players[state.presence.user_id] = player_instance

  get_tree().current_scene.get_node("Players").add_child(player_instance, true)


func _on_received_position_state(state: NakamaRTAPI.MatchData):
  var data = str_to_var(json.parse_string(state.data) )

  if players.has(state.presence.user_id):
    players[state.presence.user_id].global_position = data


func _on_received_rotation_state(state: NakamaRTAPI.MatchData):
  var data = str_to_var(json.parse_string(state.data) )

  if players.has(state.presence.user_id):
    players[state.presence.user_id].rotation = data

extends CanvasLayer

@onready
var item_list: ItemList = $MarginContainer/VBoxContainer/ScrollContainer/ItemList

func _ready():
  set_process(false)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button.pressed.connect(_on_start_button_pressed)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button2:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.pressed.connect(_on_back_button_pressed)

  NetworkSocket.socket.received_match_presence.connect(_on_received_match_presence)
  NetworkSocket.socket.received_match_state.connect(_on_received_match_state)


func _on_start_button_pressed():
  await Networking.send(0, "running")
  get_tree().change_scene_to_file("res://Room.tscn")


func _on_back_button_pressed():
  await Networking.leave()
  get_tree().change_scene_to_file("res://Title.tscn")


func _on_received_match_presence(event: NakamaRTAPI.MatchPresenceEvent):
  for join in event.joins:
    if item_list:
      item_list.add_item(join.username)


func _on_received_match_state(state: NakamaRTAPI.MatchData):
  match state.op_code:
    0:
      if state.data == "running":
        get_tree().change_scene_to_file("res://Room.tscn")


func draw():
  if item_list:
    item_list.clear()

  for presence in RoomManager.room.presences:
    if item_list:
      item_list.add_item(presence.username)

  if item_list:
    item_list.add_item(RoomManager.room.self_user.username)

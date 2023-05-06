extends CanvasLayer

@onready
var item_list: ItemList = $MarginContainer/VBoxContainer/ScrollContainer/ItemList

# Current selected room identifier.
var identifier: String

func _ready():
  if item_list:
    item_list.item_selected.connect(_on_item_selected)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button.pressed.connect(_on_refresh_button_pressed)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button2:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.disabled = true
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.pressed.connect(_on_join_button_pressed)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button3:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button3.pressed.connect(_on_create_button_pressed)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button4:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button4.pressed.connect(_on_logout_button_pressed)

  list()


func _on_item_selected(index: int):
  identifier = item_list.get_item_text(index)

  if identifier:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.disabled = false
  else:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.disabled = true


func _on_refresh_button_pressed():
  identifier = ""

  if identifier:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.disabled = false
  else:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.disabled = true

  list()


func _on_join_button_pressed():
  var status = await RoomManager.join(identifier)

  if status == OK:
    get_tree().change_scene_to_file("res://Lobby.tscn")


func _on_create_button_pressed():
  var status = await RoomManager.create()

  if status == OK:
    get_tree().change_scene_to_file("res://Lobby.tscn")


func _on_logout_button_pressed():
  if await NetworkSession.logout() == OK:
    get_tree().change_scene_to_file("res://Login.tscn")


func list():
  if item_list:
    item_list.clear()

  var rooms = await RoomManager.list()

  for room in rooms:
    if item_list:
      item_list.add_item(room.match_id)

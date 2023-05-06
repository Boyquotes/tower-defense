extends Node

var rooms: NakamaAPI.ApiMatchList

var room: NakamaRTAPI.Match # Current match.

var host: bool = false:
  set(value):
    push_error("Can't override RoomManager host.")
  get:
    return false

func _ready():
  set_process(false)


func list():
  if not NetworkClient.client:
    return

  if not NetworkSession.session:
    return

  rooms = await NetworkClient.client.list_matches_async(NetworkSession.session, 0, 6, 10, false, "", "")

  if rooms:
    return rooms.matches


func create():
  if not NetworkSocket.socket:
    return

  room = await NetworkSocket.socket.create_match_async()

  if room.is_exception():
    return room.get_exception().status_code
  else:
    return OK


func join(identifier: String):
  if not NetworkSocket.socket:
    return

  room = await NetworkSocket.socket.join_match_async(identifier)

  if room.is_exception():
    return room.get_exception().status_code
  else:
    return OK

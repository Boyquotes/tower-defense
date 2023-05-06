extends Node

var socket: NakamaSocket

func _ready():
  set_process(false)


func initialize():
  socket = Nakama.create_socket_from(NetworkClient.client)

  var connection: NakamaAsyncResult = await socket.connect_async(NetworkSession.session)

  if connection.is_exception():
    return connection.get_exception().status_code
  else:
    return OK

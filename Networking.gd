extends Node

var client: NakamaClient = Nakama.create_client("defaultkey", "187.74.33.93", 7350, "http")

var session: NakamaSession

var account: NakamaAPI.ApiAccount # Contains user information like the username.

var socket: NakamaSocket

var room: NakamaRTAPI.Match # Current match.

var host: bool = false :
  get:
    return room and account and account.user.id == room.self_user.user_id

func authenticate(email: String, password: String):
  session = await client.authenticate_email_async(email, password, null, false) # Does not registers!

  if session.is_exception():
    return session.get_exception().status_code
  else:
    return OK


func connect_to_account():
  account = await client.get_account_async(session)

  if account.is_exception():
    return account.get_exception().status_code
  else:
    return OK


func connect_to_server():
  socket = Nakama.create_socket_from(client)

  var connection: NakamaAsyncResult = await socket.connect_async(session)

  if connection.is_exception():
    return session.get_exception().status_code

  return OK


func disconnect_from_server():
  var status = await client.session_logout_async(session)

  if status.is_exception():
    return status.get_exception().status_code

  # Clears the session.
  session = null

  # Clears the account.
  account = null

  # Clears the socket.
  socket = null

  # Clears the room.
  room = null

  return OK


func matches():
  var response = await client.list_matches_async(session, 0, 6, 10, false, "", "")

  if response:
    return response.matches
  else:
    return {}


func create():
  room = await socket.create_match_async()

  if room.is_exception():
    return room.get_exception().status_code

  return OK


func join(identifier: String):
  room = await socket.join_match_async(identifier)

  if room.is_exception():
    return room.get_exception().status_code

  return OK


func leave():
  var status = await socket.leave_match_async(Networking.room.match_id)

  if status.is_exception():
    return status.get_exception().status_code

  return OK


func send(operation: int, data: String):
  return Networking.socket.send_match_state_async(room.match_id, operation, data)

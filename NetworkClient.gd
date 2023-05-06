extends Node

var _key: String = "defaultkey":
  set(value):
    push_error("Can't override NetworkClient key.")

var _address: String = "187.74.33.93":
  set(value):
    push_error("Can't override NetworkClient address.")

var _port: int = 7350:
  set(value):
    push_error("Can't override NetworkClient port.")

var client: NakamaClient = Nakama.create_client(_key, _address, _port, "http"):
  set(value):
    push_error("Can't override NetworkClient client.")

func _ready():
  set_process(false)


func login(email: String, password: String, username = null, create: bool = true, variables = null):
  return await client.authenticate_email_async(email, password, username, create, variables)


func logout(session: NakamaSession):
  return await client.session_logout_async(session)

extends Node

var session: NakamaSession

func _ready():
  set_process(false)


func login(email: String, password: String):
  session = await NetworkClient.login(email, password, null, false) # Does not registers!

  if session.is_exception():
    return session.get_exception().status_code
  else:
    return OK


func logout():
  var response = await NetworkClient.logout(session)

  if response.is_exception():
    return response.get_exception().status_code
  else:
    session = null # Clears the current session
    return OK

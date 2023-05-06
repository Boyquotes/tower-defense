extends CanvasLayer

func _ready():
  if $MarginContainer/VBoxContainer/VBoxContainer3/Button:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button.pressed.connect(_on_login_button_pressed)

  if $MarginContainer/VBoxContainer/VBoxContainer3/Button2:
    $MarginContainer/VBoxContainer/VBoxContainer3/Button2.pressed.connect(_on_quit_button_pressed)


func _on_login_button_pressed():
  if await NetworkSession.login($MarginContainer/VBoxContainer/VBoxContainer2/TextEdit.text, $MarginContainer/VBoxContainer/VBoxContainer2/TextEdit2.text) == OK:
    if await NetworkSocket.initialize() == OK:
        get_tree().change_scene_to_file("res://Title.tscn")


func _on_quit_button_pressed():
  get_tree().quit()

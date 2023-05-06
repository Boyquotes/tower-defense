class_name Player extends CharacterBody2D

var json = JSON.new()

@onready
var velocity_component: VelocityComponent = $VelocityComponent

func is_authority():
  return Networking.account.user.username == name


func _enter_tree():
  if is_authority():
    Networking.send(1, json.stringify(var_to_str(global_position) ) )


func _physics_process(_delta):
  if is_authority():
    var direction = Input.get_vector("INGAME_MOVE_LEFT", "INGAME_MOVE_RIGHT", "INGAME_MOVE_UP", "INGAME_MOVE_DOWN")

    if direction.is_zero_approx():
      velocity_component.decelerate()
    else:
      velocity_component.accelerate(direction)

    velocity = velocity_component.velocity

    move_and_slide()

    # Send position to the network
    Networking.send(2, json.stringify(var_to_str(global_position) ) )

    # Rotation
    rotation = (
      get_global_mouse_position() - global_position
    ).angle()

    # Send rotation to the network
    Networking.send(3, json.stringify(var_to_str(rotation) ) )

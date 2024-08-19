extends StaticBody2D

@onready var button = get_node(get_meta("button"))
@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var initPos = position 
@onready var targetPos = position + Vector2(0, -48)

var active = false


func _physics_process(delta):
	if button.pressed:
		position.y = move_toward(position.y, targetPos.y, 0.2)
	


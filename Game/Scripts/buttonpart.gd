extends StaticBody2D

@onready var button = get_node(get_meta("button"))
@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D



func _physics_process(delta):
	if button.pressed:
		sprite.modulate.a = 0.5
		collision_shape_2d.disabled = true
	else:
		sprite.modulate.a = 1
		collision_shape_2d.disabled = false
	


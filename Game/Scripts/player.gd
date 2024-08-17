extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -500.0
@onready var camera = $Camera2D
@onready var sprite = $AnimatedSprite2D

const setSizes = [0.04, 0.2, 1, 5, 25]
var sizeIndex = 3:
	set(value):
		sizeIndex = clamp(value, 0, setSizes.size() - 1)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000
var size = 1

var targetSize = 1	


func _physics_process(delta):
	
	if is_on_floor():
		if Input.is_action_just_pressed("grow"):
			sizeIndex += 1
		if Input.is_action_just_pressed("shrink"):
			sizeIndex -= 1
	
	var targetSize = setSizes[sizeIndex]
	var newSize = move_toward(size, targetSize, size * 0.05)
	var sizeChange = newSize / size
	
	if sizeChange != 1:
		size = newSize
		position /= sizeChange
		
	if sizeChange == 1:
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("left", "right")
		velocity.x = direction * SPEED
		
		if direction != 0:
			sprite.flip_h = direction == -1

		move_and_slide()

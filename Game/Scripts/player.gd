extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -380.0
const friction = 0.10
const stopFriction = 0.3
@onready var camera = $Camera2D
@onready var sprite = $AnimatedSprite2D
@onready var shape_cast_2d = $ShapeCast2D

const setSizes = [0.5,1,2]
const speedScaling = 0.0
const cameraScaling = 0.5
const jumpScaling = 0.5

var sizeIndex = 1:
	set(value):
		sizeIndex = clamp(value, 0, setSizes.size() - 1)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000
var size = setSizes[sizeIndex]

var targetSize = size	
var coyotteFrames = 0
var jumpBufferFrames = 0


func _physics_process(delta):
	
	if is_on_floor():
		if Input.is_action_just_pressed("grow"):
			if not shape_cast_2d.is_colliding():
				sizeIndex += 1
		if Input.is_action_just_pressed("shrink"):
			sizeIndex -= 1
	
	var targetSize = setSizes[sizeIndex]
	var newSize = move_toward(size, targetSize, size * 0.02)
	var sizeChange = newSize / size
	
	if sizeChange != 1:
		size = newSize
		scale = Vector2.ONE * size
		camera.zoom = Vector2.ONE * 2 / pow(size, cameraScaling)
		velocity = Vector2.ZERO
		
	if sizeChange == 1:
		if not is_on_floor():
			velocity.y += gravity * delta

		if is_on_floor():
			coyotteFrames = 6
		if Input.is_action_just_pressed("jump"):
			jumpBufferFrames = 8
		if jumpBufferFrames > 0 and coyotteFrames > 0:
			velocity.y = JUMP_VELOCITY * pow(size, jumpScaling)
			coyotteFrames = 0
			jumpBufferFrames = 0
			
		coyotteFrames -= 1
		jumpBufferFrames -= 1
		
		var direction = Input.get_axis("left", "right")
		velocity.x += direction * SPEED * pow(size, speedScaling)
		
		if direction != 0:
			sprite.flip_h = direction == -1

		move_and_slide()
		
		if direction == 0:
			velocity.x *= 1 - stopFriction
		else:
			velocity.x *= 1 - friction
		
		if is_on_ceiling():
			velocity.x = 0

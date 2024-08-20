extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -380.0
const friction = 0.10
const stopFriction = 0.3

@onready var camera = $Camera2D
@onready var sprite = $AnimatedSprite2D
@onready var shape_cast_2d = $ShapeCast2D
@onready var energy:int = get_meta("StartingEnergy")
@onready var infinite = get_meta("InfiniteSize")


@onready var setSizes = get_meta("SetSizes")
const speedScaling = 0.0
const cameraScaling = 0.5
const jumpScaling = 0.5

@onready var sizeIndex:int = get_meta("StartingSize"):
	set(value):
		sizeIndex = clamp(value, 0, setSizes.size() - 1)
		if infinite:
			sizeIndex = value

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000
@onready var size = setSizes[sizeIndex]

@onready var targetSize = size	
var coyotteFrames = 0
var jumpBufferFrames = 0
var changingSize = false

var freezeTime = 0

func _ready():
	scale = Vector2.ONE * size
	camera.zoom = Vector2.ONE * 2 / pow(size, cameraScaling)
	sprite.play("enter")
	freezeTime = 0.65


func _physics_process(delta):
	if freezeTime > 0: 
		freezeTime -= delta
		return
		
	var direction = Input.get_axis("left", "right")
	
	if infinite:
		if	Input.is_action_just_pressed("grow"):
			sizeIndex += 1
		if Input.is_action_just_pressed("shrink"):
			sizeIndex -= 1
			
	elif is_on_floor() and energy > 0 and not changingSize:
		if Input.is_action_just_pressed("grow") and sizeIndex < setSizes.size() - 1:
			if not shape_cast_2d.is_colliding():
				sizeIndex += 1
				energy -= 1
		if Input.is_action_just_pressed("shrink") and sizeIndex > 0:
			sizeIndex -= 1
			energy -= 1
	
	var targetSize
	if infinite:
		targetSize = pow(2, sizeIndex)
	else:
		targetSize = setSizes[sizeIndex]
	var newSize = move_toward(size, targetSize, size * 0.02)
	var sizeChange = newSize / size
	changingSize = sizeChange != 1
	
	if changingSize:
		size = newSize
		scale = Vector2.ONE * size
		camera.zoom = Vector2.ONE * 2 / pow(size, cameraScaling)
		velocity = Vector2.ZERO
		
	if not changingSize:
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
		
		velocity.x += direction * SPEED * pow(size, speedScaling)
		
		if direction != 0:
			sprite.flip_h = direction == -1

		move_and_slide()
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("Spike"):
				get_tree().reload_current_scene()
				return
		
		if is_on_ceiling():
			velocity.x = 0

	if direction == 0 or changingSize:
		velocity.x *= 1 - stopFriction
		sprite.play("idle")
	else:
		velocity.x *= 1 - friction
		sprite.play("walk")
		
func exit():
	freezeTime = 1
	sprite.play("exit")

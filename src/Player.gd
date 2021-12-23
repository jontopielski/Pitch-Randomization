extends KinematicBody2D

signal jumped

const SPEED = 150.0
const ACCELERATION = 25.0

const GRAVITY_SPEED = 120.0
const GRAVITY_ACCELERATION = 30.0

var input_strength = 0.0
var velocity = Vector2.ZERO
var state = State.FALL

enum State {
	IDLE,
	WALK,
	JUMP,
	FALL
}

func _physics_process(delta):
	input_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if !is_equal_approx(input_strength, 0.0):
		$Sprite.flip_h = true if input_strength < 0.0 else false
	match state:
		State.IDLE:
			$AnimationPlayer.play("idle")
			if Input.is_action_pressed("ui_accept"):
				emit_signal("jumped")
				state = State.JUMP
			elif !is_equal_approx(input_strength, 0.0):
				state = State.WALK
			else:
				velocity.x = lerp(velocity.x, 0.0, ACCELERATION * delta)
				velocity = move_and_slide(velocity, Vector2.UP)
		State.WALK:
			$AnimationPlayer.play("idle")
			velocity.x = lerp(velocity.x, input_strength * SPEED, ACCELERATION * delta)
			velocity = move_and_slide(velocity, Vector2.UP)
			if Input.is_action_pressed("ui_accept"):
				emit_signal("jumped")
				state = State.JUMP
			elif is_equal_approx(input_strength, 0.0):
				state = State.IDLE
		State.JUMP:
			$AnimationPlayer.play("jump")
			velocity.y = lerp(velocity.y, -GRAVITY_SPEED, GRAVITY_ACCELERATION * delta)
			velocity.x = lerp(velocity.x, input_strength * SPEED, ACCELERATION * delta)
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_equal_approx(velocity.y, -GRAVITY_SPEED):
				state = State.FALL
		State.FALL:
			$AnimationPlayer.play("idle")
			velocity.y = lerp(velocity.y, GRAVITY_SPEED, GRAVITY_ACCELERATION * delta)
			velocity.x = lerp(velocity.x, input_strength * SPEED, ACCELERATION * delta)
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_on_floor():
				state = State.IDLE


extends KinematicBody2D

onready var rayLeft = get_node("RayLeft")
onready var rayRight = get_node("RayRight")
onready var character = get_node("AnimatedSprite")

var life = true

var left = false
var right = false
var up = false
var end = false

signal dead
signal end
signal coin

###########################################

const GRAVITY = 1100.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 300
const STOP_FORCE = 1300
const JUMP_SPEED = 700
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _fixed_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = (Input.is_action_pressed("move_left") or left) and life
	var walk_right = (Input.is_action_pressed("move_right") or right or end) and life
	var jump = (Input.is_action_pressed("jump") or up) and life
	
	var stop = true
	
	if (walk_left):
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			force.x -= WALK_FORCE
			stop = false
	elif (walk_right):
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			force.x += WALK_FORCE
			stop = false
	
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		
		velocity.x = vlen*vsign
	
	# Integrate forces to velocity
	velocity += force*delta
	
	# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	
	var floor_velocity = Vector2()
	
	if (is_colliding()):
		# You can check which tile was collision against with this
		# print(get_collider_metadata())
		
		# Ran against something, is it the floor? Get normal
		var n = get_collision_normal()
		
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Since this formula will always slide the character around, 
			# a special case must be considered to to stop it from moving 
			# if standing on an inclined floor. Conditions are:
			# 1) Standing on floor (on_air_time == 0)
			# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
			# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
			# 4) Collider is not moving
			
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping):
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		jumped()
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	#######################
	var in_floor = rayLeft.is_colliding() or rayRight.is_colliding()
	
	if walk_right:
		character.set_flip_h(false)
	if walk_left:
		character.set_flip_h(true)
	
	if (walk_right or walk_left) and in_floor:
		character.play()
	elif walk_right or walk_left:
		character.stop()
		character.set_frame(3)
	else:
		character.stop()
		character.set_frame(1)
	
	if get_pos().y > 780:
		dead()

func _ready():
	set_fixed_process(true)

func _on_Foot_body_enter( body ):
	if not life:
		return
	jumped()
	body.smash()
	
func jumped():
	velocity.y = -JUMP_SPEED
	jumping = true

func _on_Body_body_enter( body ):
	if not life:
		return
	dead()

func dead():
	if not life:
		return
	life = false
	velocity.y = -500
	get_node("Shape").set_trigger(true)
	emit_signal("dead")
	
	get_parent().get_node("CanvasLayer/Panel/Label 2").set_text("30")
	get_parent().get_node("Game_Timer").start()


func _on_Head_body_enter( body ):
	if not life:
		return
	if body.has_method("destruct"):
		body.destruct()	

func _on_Left_pressed():
	left = true

func _on_Left_released():
	left = false

func _on_Right_pressed():
	right = true

func _on_Right_released():
	right = false

func _on_Up_pressed():
	up = true

func _on_Up_released():
	up = false
	
func spawn():
	velocity = Vector2(0, 0)
	get_node("Shape").set_trigger(false)
	get_node("Camera2D").make_current()
	life = true
	end = false

func _on_End_body_enter( body ):
	end = true
	emit_signal("end")
	
func coin():
	emit_signal("coin")

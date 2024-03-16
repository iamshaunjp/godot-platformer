extends CharacterBody2D

var direction_x := 0.0
@export var speed = 150

var can_shoot := true

func _process(delta):
	get_input()
	apply_gravity()
	
	velocity.x = direction_x * speed
	move_and_slide()
		
func get_input():
	direction_x = Input.get_axis("left", "right")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -200
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		print('shoot')
		can_shoot = false
		$Timers/CooldownTimer.start()

func apply_gravity():
	velocity.y += 20


func _on_cooldown_timer_timeout():
	can_shoot = true

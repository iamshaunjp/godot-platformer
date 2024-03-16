extends CharacterBody2D

var direction_x := 0.0
var facing_right := true
@export var speed = 150

var can_shoot := true
var has_gun := false
var vulnerable := true

signal shoot(pos: Vector2, direction: bool)

var health := 100

func _process(_delta):
	get_input()
	apply_gravity()
	get_facing_direction()
	get_animation()
	
	velocity.x = direction_x * speed
	move_and_slide()
		
func get_input():
	direction_x = Input.get_axis("left", "right")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -200
	
	if Input.is_action_just_pressed("shoot") and can_shoot and has_gun:
		shoot.emit(global_position, facing_right)
		can_shoot = false
		$Timers/CooldownTimer.start()
		$Timers/FireTimer.start()
		$Fire.get_child(facing_right).show()

func apply_gravity():
	velocity.y += 20

func get_facing_direction():
	if direction_x != 0:
		facing_right = direction_x >= 0

func get_animation():
	var animation = 'idle'
	if not is_on_floor():
		animation = 'jump'
	elif direction_x != 0:
		animation = 'walk'
	if has_gun:
		animation += '_gun'
		
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.flip_h = not facing_right

func _on_cooldown_timer_timeout():
	can_shoot = true


func _on_fire_timer_timeout():
	for child in $Fire.get_children():
		child.hide()

func get_damage(amount):
	if vulnerable:
		health -= amount
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
		vulnerable = false
		$Timers/InvincibilityTimer.start()

func _on_invincibility_timer_timeout():
	vulnerable = true

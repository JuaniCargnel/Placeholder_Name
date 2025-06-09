extends CharacterBody2D

# === CONFIGURACIÓN ===
@export var speed := 100
@export var dash_distance := 100
@export var dash_duration := 0.2
@export var dash_cooldown := 1.0
@export var invuln_duration := 0.3

# === ESTADO ===
var can_dash := true
var is_invulnerable := false
var is_dashing := false
var is_dead := false
var is_falling := true
var dash_direction := Vector2.ZERO
var dash_elapsed := 0.0

# === MANOS ===
var orbit_radius := 20
var attack_cooldown := 0.3
var attack_timer := 0.0
var current_hand := 0

# === REFERENCIAS ===
@onready var anim := $AnimatedSprite2D
@onready var dash_timer := $DashTimer
@onready var invuln_timer := $InvulnTimer
@onready var left_hand := $HandsRoot/LeftHand
@onready var right_hand := $HandsRoot/RightHand

# === INICIO ===
func _ready():
	anim.play("fall")
	velocity = Vector2.ZERO

# === LÓGICA PRINCIPAL ===
func _physics_process(delta):
	if is_dead or is_falling:
		return

	# Si está haciendo dash, moverse manualmente
	if is_dashing:
		dash_elapsed += delta
		var t := dash_elapsed / dash_duration
		if t >= 1.0:
			is_dashing = false
			velocity = Vector2.ZERO
		else:
			velocity = dash_direction * (dash_distance / dash_duration)
			move_and_slide()
		return

	# Movimiento normal
	velocity = InputManager.get_input_vector() * speed
	move_and_slide()

	# Animaciones de movimiento
	if velocity.length() > 0:
		anim.play("run")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("idle")

	# Input de dash
	if Input.is_action_just_pressed("dash") and can_dash and velocity.length() > 0:
		start_dash()

# === PROCESO VISUAL ===
func _process(delta: float) -> void:
	if is_dead or is_falling:
		return

	# Ángulo hacia el mouse
	var mouse_angle = (get_global_mouse_position() - global_position).angle()

	# Posiciones fijas a los lados del ángulo (como "manos en V")
	var left_offset = Vector2(orbit_radius, 0).rotated(mouse_angle - PI / 4)
	var right_offset = Vector2(orbit_radius, 0).rotated(mouse_angle + PI / 4)

	left_hand.global_position = global_position + left_offset
	right_hand.global_position = global_position + right_offset

	# Rotar raíz de manos hacia el mouse
	$HandsRoot.look_at(get_global_mouse_position())

	# Ataque por turnos
	attack_timer -= delta
	if Input.is_action_just_pressed("attack") and attack_timer <= 0:
		attack_timer = attack_cooldown
		var hand = left_hand if current_hand == 0 else right_hand
		current_hand = (current_hand + 1) % 2
		hand_attack(hand)

# === DASH ===
func start_dash():
	can_dash = false
	is_invulnerable = true
	is_dashing = true
	dash_elapsed = 0.0
	dash_direction = velocity.normalized()

	invuln_timer.start(invuln_duration)
	dash_timer.start(dash_cooldown)

# === ATAQUE DE MANO ===
func hand_attack(hand: Node2D):
	var dir = (get_global_mouse_position() - hand.global_position).normalized()
	var punch_distance := 30

	var tween := create_tween()
	tween.tween_property(hand, "global_position", hand.global_position + dir * punch_distance, 0.1)
	tween.tween_property(
		hand,
		"global_position",
		global_position + (hand.global_position - global_position).normalized() * orbit_radius,
		0.1
	).set_delay(0.1)

# === DAÑO ===
func receive_damage(_amount: int):
	if is_invulnerable or is_dead:
		return
	anim.play("hurt")

# === MUERTE ===
func die():
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("death")

# === CALLBACKS DE TIMERS ===
func _on_dash_timer_timeout() -> void:
	can_dash = true

func _on_invuln_timer_timeout() -> void:
	is_invulnerable = false

# === CALLBACK ANIMACIONES ===
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "fall":
		is_falling = false

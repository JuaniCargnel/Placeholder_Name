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

# === REFERENCIAS ===
@onready var anim := $AnimatedSprite2D
@onready var dash_timer := $DashTimer
@onready var invuln_timer := $InvulnTimer

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

# === DASH ===
func start_dash():
	can_dash = false
	is_invulnerable = true
	is_dashing = true
	dash_elapsed = 0.0
	dash_direction = velocity.normalized()

	invuln_timer.start(invuln_duration)
	dash_timer.start(dash_cooldown)

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

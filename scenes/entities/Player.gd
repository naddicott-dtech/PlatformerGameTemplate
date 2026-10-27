extends CharacterBody2D
# Move, jump, fall, respawn. All game-feel numbers are Inspector knobs.
enum Controls { PLAYER_ONE, PLAYER_TWO }
enum Affinity { NEUTRAL, LIGHT, DARK }
@export var controls: Controls = Controls.PLAYER_ONE
@export var affinity: Affinity = Affinity.NEUTRAL
@export var display_name := "player"
@export var picture: Texture2D
@export_group("Movement")
@export_range(20, 600, 10) var move_speed := 260.0
@export_range(100, 900, 10) var jump_speed := 520.0
@export_range(100, 3000, 50) var gravity := 1400.0
@export_group("Recovery")
@export var fall_limit := 850.0
@export_range(0, 2, 0.05) var respawn_grace := 0.4
var checkpoint := Vector2.ZERO
var respawning := false
var grace_left := 0.0

func _ready() -> void:
	add_to_group("players")
	checkpoint = global_position
	$Label.text = display_name
	if picture != null:
		$Sprite2D.texture = picture

func _physics_process(delta: float) -> void:
	grace_left = maxf(0, grace_left - delta)
	if Globals.won or respawning:
		velocity = Vector2.ZERO
		return
	var prefix := "p1_" if controls == Controls.PLAYER_ONE else "p2_"
	velocity.x = Input.get_axis(prefix + "left", prefix + "right") * move_speed
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed(prefix + "jump") and is_on_floor():
		velocity.y = -jump_speed
	move_and_slide()
	if global_position.y > fall_limit:
		die()

func set_checkpoint(point: Vector2) -> void:
	checkpoint = point

func die() -> void:
	if respawning or Globals.won or grace_left > 0:
		return
	respawning = true
	Globals.deaths += 1
	SignalBus.state_changed.emit()
	SignalBus.message.emit(display_name + ": back to the checkpoint.")
	# Area signals happen during physics. Move after that pass has finished.
	_respawn.call_deferred()

func _respawn() -> void:
	global_position = checkpoint
	velocity = Vector2.ZERO
	grace_left = respawn_grace
	respawning = false

@tool
extends Area2D
# Same building block: choose what touching it does, then tune its fields.
enum Kind { HAZARD, CHECKPOINT, EXIT, SWITCH, CUSTOM }
enum Affects { EVERYONE, LIGHT, DARK }
@export var kind: Kind = Kind.HAZARD
## For hazards: who gets hurt. For switches/checkpoints: who may use them.
@export var affects: Affects = Affects.EVERYONE
@export var display_name := "hazard":
	set(value):
		display_name = value
		_refresh()
@export var size := Vector2(80, 28):
	set(value):
		size = Vector2(maxf(8,value.x),maxf(8,value.y))
		_refresh()
@export var picture: Texture2D:
	set(value):
		picture = value
		_refresh()
@export_multiline var message := "Change this message."
@export_group("Switch")
@export var flag_id := ""
@export_group("Checkpoint")
## Put the respawn point on safe ground, outside hazards.
@export var spawn_offset := Vector2(0,-35)
@export_group("Exit")
@export var required_flags: PackedStringArray = []
var activated_players: Array[int] = []

func _ready() -> void:
	_refresh()
	if not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)

func _refresh() -> void:
	if not is_node_ready():
		return
	var shape := RectangleShape2D.new()
	shape.size = size
	$CollisionShape2D.shape = shape
	$Picture.position = -size/2
	$Picture.size = size
	$Picture.texture = picture
	$Label.text = display_name
	$Label.position = Vector2(-size.x/2,-size.y/2-25)

func accepts(player: Node) -> bool:
	return affects == Affects.EVERYONE or int(affects) == int(player.affinity)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("players"):
		activate(body)

func activate(player: Node) -> void:
	if Globals.won or player.respawning or not accepts(player):
		return
	match kind:
		Kind.HAZARD:
			player.die()
		Kind.CHECKPOINT:
			player.set_checkpoint(global_position + spawn_offset)
			if player.get_instance_id() not in activated_players:
				activated_players.append(player.get_instance_id())
				SignalBus.message.emit(player.display_name + ": " + message)
		Kind.SWITCH:
			if flag_id == "":
				SignalBus.message.emit("Set Flag Id on " + display_name)
			elif flag_id not in Globals.flags:
				Globals.flags.append(flag_id)
				SignalBus.state_changed.emit()
				SignalBus.message.emit(message)
		Kind.CUSTOM:
			custom_action(player)
		# EXIT is checked continuously below so both players must be here now.

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() or Globals.won:
		return
	if kind == Kind.EXIT:
		if can_finish(get_overlapping_bodies(), get_tree().get_nodes_in_group("players")):
			Globals.won = true
			SignalBus.state_changed.emit()
			SignalBus.message.emit(message)
	elif kind == Kind.HAZARD:
		# A player whose grace ends while standing in a hazard must still die.
		for body in get_overlapping_bodies():
			if body.is_in_group("players"):
				activate(body)

func can_finish(inside: Array, players: Array) -> bool:
	if players.is_empty():
		return false
	for flag in required_flags:
		if flag not in Globals.flags:
			return false
	for player in players:
		if player not in inside or player.respawning or not accepts(player):
			return false
	return true

func custom_action(_player: Node) -> void:
	# PUT YOUR NEW TOUCH INTERACTION HERE. Select CUSTOM in the Inspector.
	# Duplicate this script for a special object, then attach the copy to it.
	# Main and the player controller do not need to change.
	pass

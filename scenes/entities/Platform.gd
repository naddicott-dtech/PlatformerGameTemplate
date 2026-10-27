@tool
extends StaticBody2D
# One Size field updates the picture AND collision. Duplicate freely.
@export var size := Vector2(160, 24):
	set(value):
		size = Vector2(maxf(8,value.x),maxf(8,value.y))
		_refresh()
@export var picture: Texture2D:
	set(value):
		picture = value
		_refresh()
@export var display_name := "platform":
	set(value):
		display_name = value
		_refresh()
## Blank = solid forever. A switch with this Flag Id opens this gate.
@export var opens_when_flag := ""

func _ready() -> void:
	_refresh()
	if not Engine.is_editor_hint():
		SignalBus.state_changed.connect(_update_gate)
		_update_gate()

func _refresh() -> void:
	if not is_node_ready():
		return
	var shape := RectangleShape2D.new()
	shape.size = size
	$CollisionShape2D.shape = shape
	$Picture.position = -size / 2
	$Picture.size = size
	$Picture.texture = picture
	$Label.text = display_name
	$Label.position = Vector2(-size.x/2,-size.y/2-25)

func _update_gate() -> void:
	var open := opens_when_flag != "" and opens_when_flag in Globals.flags
	visible = not open
	set_deferred("collision_layer",0 if open else 1)

extends Node
@export var world_root: Node
@export var solo_level: PackedScene
@export var coop_level: PackedScene
@export_enum("Solo", "Light & Dark") var starting_example := 0
var current_level: PackedScene

func _ready() -> void:
	load_level(solo_level if starting_example == 0 else coop_level)

func show_solo() -> void:
	load_level(solo_level)

func show_coop() -> void:
	load_level(coop_level)

func restart() -> void:
	load_level(current_level)

func load_level(scene: PackedScene) -> void:
	if scene == null:
		SignalBus.message.emit("Assign the level scene on LevelManager.")
		return
	for old in world_root.get_children():
		world_root.remove_child(old)
		old.queue_free()
	Globals.reset()
	current_level = scene
	world_root.add_child(scene.instantiate())
	SignalBus.state_changed.emit()
	SignalBus.message.emit("Touch a checkpoint before taking a risk.")

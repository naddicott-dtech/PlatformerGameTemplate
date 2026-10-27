extends Node
# Only facts that this run needs. Inspector knobs live on scene nodes.
var flags: Array[String] = []
var deaths := 0
var won := false

func reset() -> void:
	flags.clear()
	deaths = 0
	won = false
	SignalBus.state_changed.emit()

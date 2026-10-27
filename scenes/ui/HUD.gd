extends Control
@export var level_manager: Node

func _ready() -> void:
	$Solo.pressed.connect(level_manager.show_solo)
	$Coop.pressed.connect(level_manager.show_coop)
	$Restart.pressed.connect(level_manager.restart)
	SignalBus.state_changed.connect(_refresh)
	SignalBus.message.connect(func(text): $Message.text = text)
	_refresh()

func _refresh() -> void:
	$Status.text = "COMPLETE! Change a level and try again." if Globals.won else "Falls: %d   Switches: %s" % [Globals.deaths,", ".join(Globals.flags)]
	if level_manager.world_root.get_child_count() > 0:
		$Mission.text = level_manager.world_root.get_child(0).mission

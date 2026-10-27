# Make it yours

Start with Inspector changes, then take the code door only when you need it.

1. Replace every placeholder picture and label.
2. Make three different jump feels; record speed/jump/gravity and finish times.
3. Build a different solo route with at least two safe checkpoints.
4. Make a hazard only Light can cross safely. Explain Affects to a partner.
5. Add a third switch and gate using a new matching flag name.
6. Require that flag at the exit. Test refusing to touch the switch.
7. Build a route where each player helps the other in turn.
8. Add a custom zone that changes the touching player's jump speed.

## Code challenge 8: a launch-power pickup

Duplicate `Zone.gd` as `JumpPickup.gd`, attach it to one Zone instance, select **Kind = Custom**, and add this Inspector field near the other exports:

```gdscript
@export var new_jump_speed := 700.0
```

Replace the marked `custom_action` stub with:

```gdscript
func custom_action(player: Node) -> void:
    player.jump_speed = new_jump_speed
    SignalBus.message.emit(message)
```

Set Message to explain the new power. This changes only the player who touches the zone; it survives death because the player is repositioned, and Restart creates a fresh player. Check that touching it changes jump height, the other player is unchanged, and Restart restores the original number. This extension uses the same existing touch/affinity path as the built-in zones; you don't need to edit Main or connect signals.

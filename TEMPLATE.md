# Platformer — context and editing map

Godot 4.5, pure GDScript, Compatibility; one-screen solo and Light & Dark local co-op.

## Scene map

`Main → Managers/LevelManager + WorldRoot + UI/HUD`. LevelManager instances a level under WorldRoot. Levels contain `Platforms` and `Entities`. Player moves; Zone handles touch rules; Platform handles optional flag gates. SignalBus carries message and state_changed. Globals stores flags, deaths, won only (no hidden tuning settings).

## Inspector knobs

| Script | Exports |
|---|---|
| Player | controls: enum input slot; affinity: enum rule identity; display_name: String; picture: Texture2D; move_speed, jump_speed, gravity: float; fall_limit: float Y boundary; respawn_grace: float seconds |
| Platform | size: Vector2 art/collision; picture: Texture2D; display_name: String; opens_when_flag: String, empty = always solid |
| Zone | kind: enum Hazard/Checkpoint/Exit/Switch/Custom; affects: enum Everyone/Light/Dark; display_name: String; size: Vector2; picture: Texture2D; message: multiline String; flag_id: String for switch; spawn_offset: Vector2 for checkpoint; required_flags: PackedStringArray for exit |
| Level | mission: multiline String |
| LevelManager | world_root: Node reference; solo_level, coop_level: PackedScene; starting_example: enum |
| HUD | level_manager: Node reference (prewired) |

## Duplicatable blocks and roles

Player.tscn, Platform.tscn, Zone.tscn. Artists replace Picture; designers place blocks and tune exported fields; writers change Mission/Message; programmers extend the marked custom_action block in a copied Zone script. No manual signal connections. Start with README recipes.

## Behavior contracts

Grounded jump only. Layer 1 is solid world, layer 2 is players; players do not collide with each other. Hazards are Area2D triggers, filtered by affinity. Checkpoints belong to the touching player. Death is deferred outside the physics callback and retains flags. Restart/example switch resets flags, deaths, win, and checkpoint positions. Exit continuously checks that all current players overlap and required flags exist. No persistence across runs.

## Common tweaks

Change jump height using jump_speed/gravity; adjust both after changing gaps. Resize platforms/zones through Size, not node scale. New gate: matching switch flag_id and platform opens_when_flag. New level: duplicate scene and assign on Main's LevelManager. New behavior: copied Zone.gd → Custom → custom_action(player); do not rewrite Main.

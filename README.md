# Platformer Game Template

A deliberately ugly, unbalanced Godot **4.5 Compatibility** starter. Make it yours by moving blocks, dropping in pictures, and changing Inspector fields. No plugins or GDScript edits are needed for the two examples.

## Start here

Download this repository as a ZIP and unzip it. Import `project.godot` into Godot 4.5, wait for assets to import, then press **F5**. Use the on-screen buttons to switch examples or restart.

| Player | Move | Jump |
|---|---|---|
| Solo / Light | A, D | W or Space |
| Dark | Left, Right | Up or Enter |

Click the game first if keys do nothing in a browser. This is local, shared-keyboard co-op. Jumping requires touching the ground; holding jump does not auto-jump. Players pass through each other. Some keyboards cannot register many simultaneous keys: remap actions in Project Settings → Input Map if needed.

**Your mission:** replace the rectangles, build a different route, and tune the jumps. Then have someone else play without your explanation.

## Two examples

- **Solo:** movement, gaps, a hazard, two checkpoints, and an exit.
- **Light & Dark:** Light can cross the pool labeled “hurts Dark”; Dark can cross “hurts Light.” The other player must jump. Light touches its switch to open gate 1; Dark opens gate 2. Both must be inside the exit together.

Death returns only that player to their most recent checkpoint. Switches stay on after deaths. Checkpoints and flags last for this run only; Restart and changing examples reset everything. There is no disk save.

## Make your first change — no code

1. Open `scenes/levels/Solo.tscn`. Select `Entities/Player`. Try **Move Speed = 220**, **Jump Speed = 600**, **Gravity = 1400**.
2. Select a node under `Platforms`. Move it with the 2D tool. Change its **Size** in the Inspector: its picture and collision rectangle resize together. Use Size rather than scaling the node.
3. Duplicate a platform or checkpoint with Cmd+D. Move it to a new spot. Put checkpoint respawns above safe ground.
4. Drop a texture into **Picture** on a Player, Platform, or Zone. Change **Display Name** to identify your object. Platform/zone pictures stretch to Size. Player artwork uses its Sprite2D scale; adjust that child for larger source art. The player's collision stays 28×36 unless you edit its CollisionShape2D.
5. Select the level root and rewrite **Mission**. Select zones and rewrite their **Message**.
6. Press F5 and test the entire route.

To make a new level, duplicate one of the example scenes. Open `scenes/Main.tscn`, select `Managers/LevelManager`, and drag your saved scene into **Solo Level** or **Coop Level**. **Starting Example** chooses which opens first. Keep the Main hierarchy and existing references; no signal wiring is necessary. This starter uses one fixed 1280×720 screen; scrolling levels are a later extension.

## Building blocks

Drag these scenes from the FileSystem into your level, or duplicate a working instance:

| Block | Inspector setup |
|---|---|
| `scenes/entities/Player.tscn` | Controls slot; Affinity Neutral/Light/Dark; movement and recovery numbers; Picture |
| `scenes/entities/Platform.tscn` | Size, Picture, Display Name. Leave Opens When Flag blank for solid ground. |
| `scenes/entities/Zone.tscn` | Kind, Affects, Size, Picture, Display Name, Message, plus fields for the chosen kind |

**Affects means who responds**, not the zone's color. For a pool that hurts Dark, choose Hazard + Affects Dark. For a switch only Light can use, choose Switch + Affects Light. Picture and label are independent: update them when you change the rule.

### Switch → door, without code

1. Duplicate a Switch zone. Set **Kind = Switch**, **Flag Id = bridge_open**, and **Affects** to the player who can activate it.
2. Duplicate a Platform, position it as a door, and set **Opens When Flag = bridge_open**.
3. Touch the switch. The door disappears and stops colliding. Names must match exactly.
4. Optionally add `bridge_open` to an Exit's **Required Flags** array.

Switches latch on; there are no pressure plates or timed switches yet. The exit requires every Player in the current level, even if you add more instances. Give an ordinary exit **Affects = Everyone**.

### Safe checkpoints

Use **Kind = Checkpoint**, **Affects = Everyone** (or choose one affinity). **Spawn Offset** is added to the checkpoint's position; the default `(0, -35)` puts the player above it. Each player must touch the checkpoint personally. Keep that spawn point clear of walls and hazards. **Fall Limit** on the player is the Y coordinate below which they respawn; **Respawn Grace** is a brief hazard immunity period.

## Who edits what?

- Artist: put textures in `assets/`; assign Picture on the labeled blocks.
- Level designer: arrange `Platforms` and `Entities`, edit Mission and zone messages.
- Tuning designer: change speed, jump, gravity, sizes, gaps, and respawn settings; record playtest results.
- Programmer: read `Player.gd` and `Zone.gd`. A marked **PUT YOUR NEW TOUCH INTERACTION HERE** block in `Zone.gd` is the extension point. Duplicate that script, attach it to a special zone, and select Kind = Custom. See `CHALLENGES.md`.

## Playtest checklist

- [ ] Can a new player understand the controls and goal?
- [ ] Can every gap be crossed using the current movement numbers?
- [ ] Do hazards return only the affected player to safe ground?
- [ ] Does each checkpoint work for both players independently?
- [ ] Can only the intended affinity activate each switch?
- [ ] Do opened gates stay open after a death and close on Restart?
- [ ] Does the co-op exit wait for both players and all required flags?
- [ ] Does replacement artwork fit the actual collision shapes? Use Debug → Visible Collision Shapes while running.
- [ ] Can someone finish your exported browser version?

## Export for the web

Install Godot 4.5 export templates through Editor → Manage Export Templates. Use Project → Export → Web, create an `html_export` folder, and export as `index.html`. Upload the whole output folder to your hosting service. For local testing, serve it with `python3 -m http.server 8768 --directory html_export` and visit `http://localhost:8768`; don't double-click the HTML. The preset uses Compatibility and no threads.

This is a small foundation: no enemies, moving platforms, animation system, networking, Ink integration, or level progression yet. Those are student extensions or later slices.

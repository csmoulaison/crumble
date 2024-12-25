# README
Run "launch.bat" to launch the game on a 64-bit Windows machine. Crumble King is a retro style arcade game about ascending 6 levels of a castle tower, eating food, and avoiding guards.

## Goals
- Eat foods as they appear to gain points.
- Avoid guards or you will lose a life and the level will reset.
- One all foods have been eaten, a cooking pot will appear. Jump on this pot to end the level.
- Floor tiles degrade as you stand on them, with a total of 3 "health" points depleted before they are destroyed.
- Each food eaten will cause you to become heavier, making it harder to get up to speed.
- Double jump to float.

## Tips + Tricks
- Jumping in the opposite direction from your current direction gives you a boost in that direction.
- Finish the game to unlock extra functionality.

## Controls
The game should work out of the box with both a keyboard and most modern game controllers. Alternative controls are not configurable. Maybe I'll add them in an update sometime.

### Keyboard controls
- Jump/Start: Space, Up-Arrow, W
- Left: Left-Arrow, A
- Right: Right-Arrow, D
- Quit/Back: Escape

### Gamepad controls
- Jump/Start: Bottom Button (i.e. "A" on Xbox controller)
- Left: D-Pad Left
- Right: D-Pad Right
- Quit/Back: Right Button (i.e. "B" on Xbox controller)

## launch.bat Configuration

### Turning off the CRT filter
To turn off the crt filter, edit "launch.bat", removing the "crt" flag so that the file reads:

> crumble.exe 

Launching the game with the "crumble.exe" file directly will have the same effect, as no configuration options will be applied to the game in this case.

### Changing the pixel scalar
Certain high DPI configurations have not been properly accounted for. If the game seems either too large or too small, you can override the pixel scale by adding "scalar" and then a whole number to the "launch.bat" file. For example, instead of:

> crumble.exe crt

This can be modified to read:

> crumble.exe crt scalar 2

This directs the renderer to draw the game at 2x scale. Try a few different options to see if the game looks better. Levels 4, 5, and 6 are quite tall, however, so this could screw with you if the scale is too large.
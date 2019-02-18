# Qtile Keybinds

**Mod = Meta (Windows key)**

## ModantTall bindings

| **Keys**  | **Action**  |
|---|---|
| Mod + h  | Select window to the left  |
| Mod + l  | Select window to the right  |
| Mod + j  | Select window down   |
| Mod + k  | Select window up  |
| Mod + Space  | Select next window  |
| Mod + Shift + h  | Move active window left  |
| Mod + Shift + l  | Move active window right  |
| Mod + Shift + j  | Move active window down  |
| Mod + Shift + k  | Move current window up |
| Mod + Shift + "+"  | Enlarge active window  |
| Mod + Shift + "-"  | Shrink active Window  |
| Mod + Shift + m  | Maximize acive window  |
| Mod + Shift + n  | Reset active window size  |
| Mod + Shift + Space  | Flip Master window [^1] |


## Layout control bindings

| **Keys**  | **Action**  |
|---|---|
| Mod + Tab  | Toggle next layout  |
| Mod + Shift + t  | Disable floating mode [^2]  |
| Mod + t  | Enable floating mode  |

## Floating mode bindings

| **Keys**  | **Action**  |
|---|---|
| Mod + Left click  | Move window around (drag)  |
| Mod + Right Click  | Re-size window (drag)  |
| Mod + Middle click  | Bring window to front  |
 
## General system control bindings

| **Keys**  | **Action**  |
|---|---|
| Mod + w  | Close active window  |
| Mod + \$n | Switch to workspace $n[^3].
| Mod + Shift + \$n | Send active window to workspace \$n
| Mod + r  | Invoke run prompt[^4]  |
| Mod + Shift + r  | Invoke D_Menu (program search bar)   |
| Mod + Control + r  | Restart QTile (reloads config file) |
| Mod + Control + q  | Log out  |
| Mod + Control + l  | Lock the screen with xscreensaver  |

## Programs bindings

| **Keys**  | **Action**  |
|---|---|
| Mod + Enter  | Spawn terminal (urxvt)  |
| Mod + g  | Spawn web browser (Chromium)   |
| Mod + f  | Spawn file manager (Ranger)   |
| Mod + m  | Spawn music player (Cmus) |
| Control + Shift + f  | Spawn file manager in current directory[^5] (**Read footnote**) |


## Special keys

| **Keys**  | **Action**  |
|---|---|
| Print  | Take screenshot of all monitors[^6] |
| Mod + Print  | Select area to screenshot  |
| 'Volume Up' Key  | Raise volume by 2dB  	|
| 'Volume Down' key  | Lower volume by 2dB  |
| 'Brightness Up' Key  | Increase screen brightness by 10  |
| 'Brightness Down' Key  | Decrease Brightness by 10       |


[^1]: Place active window on the right side of the screen
[^2]: Floating is a bit buggy, aso its not in the normal list of layouts so you can't cycle into it with Mod+Tab.
[^3]: Workspaces are callled 'groups' in QTile. The number of workspaces and their symbols an be changed in the config file, its just a string we iterate through. Currently workspaces are digits 1 through 8.
[^4]: requires exact name of programs to be entered, but can be tab-completed
[^5]: Not implemented in Qtile but in zsh, only works when working in a terminal.
[^6]: Normally it grabs a screenshot of the screen. If multiple monitors are present it will also capture the contnet of the other monitors in the same picture. Also note that you *do not* need to press Mod for this

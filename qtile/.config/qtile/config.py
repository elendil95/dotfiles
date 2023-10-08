# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, hook, layout, qtile, widget
from libqtile.backend.wayland import InputConfig
from libqtile.command import lazy
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.log_utils import logger as log
from modules import x11_display as x11d
from qtile_extras.widget import PulseVolumeExtra, StatusNotifier
from Xlib import display

# Mod Key is Windows key
# pylint: disable=invalid-name
mod = "mod4"

# Set up screens
if qtile.core.name == 'x11':
    disp = display.Display()
    x11_display = x11d.X11Display(disp, disp.screen(), disp.screen().root)
    resources = x11_display.get_screen_resources()
    num_screens = 0
    for output in resources['outputs']:
        mon = x11_display.get_monitor_info(output, resources)
        if mon['num_preferred']:
            num_screens += 1
else: # If on wayland
    num_screens = len(qtile.core.outputs)
    wl_input_rules = {'type:keyboard': InputConfig(kb_layout='it')}

scriptDir = os.path.expanduser("~/bin")
if (not os.path.isdir(scriptDir)):
    log.warning("$HOME/bin is not configured, some commands will not work correctly")

programs = {
    "browser": "firefox",
    "file-manager": "thunar",
    "password-manager": "keepassxc",
    "email-client": "thunderbird",
    "calculator": "gnome-calculator",
    "gui-app-finder": "xfce4-appfinder"
}

if qtile.core.name == "wayland":
    programs.update({
        "terminal": "alacritty",
        "music-player": "alacritty -e cmus",
        "calendar": "alacritty -e calcurse",
        "lock-script": "???", #might still work w wayland, if lightdm is supported
        "session-script": "???", #Will not work bc dmenu
        "brightness-up": "alacritty -e light -A 10",
        "brightness-down": "alacritty -e light -U 10",
        "screenshot": "???", # Dunno if it works in wayland
        "screenshot-select": "????"
    })
else:
    programs.update({
        "terminal": "urxvt",
        "music-player": "urxvt -e cmus",
        "calendar": "urxvt -e calcurse",
        "lock-script": "???", #might still work w wayland, if lightdm is supported
        "session-script": "???", #Will not work bc dmenu
        "brightness-up": "urxvt -e light -A 10",
        "brightness-down": "urxvt -e light -U 10",
        "screenshot": "???", # Dunno if it works in wayland
        "screenshot-select": "????"
    })

##-----KEYBINDS------
keys = [
    # MonadTall Bindings
    Key([mod], "h", lazy.layout.left(), desc="Focus window to the left"),
    Key([mod], "l", lazy.layout.right(), desc="Focus window to the right"),
    Key([mod], "j", lazy.layout.down(), desc="Focus window below"),
    Key([mod], "k", lazy.layout.up(), desc="Focus window above"),
    Key([mod], "space", lazy.layout.next(), desc="Focus next window"),
    Key([mod, "shift"], "h", lazy.layout.swap_left(), desc="Move current window to the left"),
    Key([mod, "shift"], "l", lazy.layout.swap_right(), desc="Move current window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move current window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move current window up"),
    Key([mod, "shift"], "plus", lazy.layout.grow(), desc="Increase the size of the current window"),
    Key([mod, "shift"], "minus", lazy.layout.shrink(), desc="Decrease the size of the current window"),
    Key([mod, "shift"], "n", lazy.layout.reset(), desc="Reset the size of the current window"),
    # Key([mod, "shift"], "m", lazy.layout.maximize()),
    Key([mod, "shift"], "space", lazy.layout.flip(), desc="Flip the position of the master and stack area (e.g from master on the left to master on the right)"),

    Key([mod], "Tab", lazy.next_layout(), desc="Cycle between layouts"),

    # Floating Layout Keybinds
    Key([mod], "t", lazy.window.enable_floating(), desc="Enable floating mode"),
    Key([mod, "shift"], "t", lazy.window.disable_floating(), desc="Disable floating mode"),

    # Window controls (layout agnostic)
    Key([mod], "w", lazy.window.kill(), desc="Close focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restat Qtile (reloads configuration)"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Quit Qtile (log out)"),

    # Programs
    Key([mod], "Return", lazy.spawn(programs["terminal"]), desc="Open Terminal"),
    Key([mod], "b", lazy.spawn(programs["browser"]), desc="Open Web browser"),
    Key([mod], "f", lazy.spawn(programs["file-manager"]), desc="Open File manager"),
    Key([mod], "m", lazy.spawn(programs["music-player"]), desc="Open Music player"),
    Key([mod], "c", lazy.spawn(programs["calendar"]), desc="Open Calendar"),
    Key([mod], "p", lazy.spawn(programs["password-manager"]), desc="Open Password manager"),
    Key([mod], "e", lazy.spawn(programs["email-client"]), desc="Open Email client"),
    Key([mod, "shift"], "c", lazy.spawn(programs["calculator"]), desc="Open Calculator"),
    Key([mod, "shift"], 'r', lazy.spawn(programs["gui-app-finder"]), desc="Open graphical app finder"),
    Key([mod], "r", lazy.spawncmd(), desc="Open Run launcher (Built-in)"),
    # Key([mod], "r", lazy.run_extension(extension.DmenuRun(dmenu_height=24)), desc="Open Run launcher (Dmenu)"), # Use dmenu wrapper
    # Key([mod], "r", lazy.spawn("dmenu_run -p 'Run:' -fn 'Monospace:size=12' -nb '#000000' -nf '#fefefe'")),
    Key([mod, "control"], "l", lazy.spawn(os.path.expanduser("~/bin/lock_screen.sh")), desc="Lock the screen"),
    Key([mod, "control"], "x", lazy.spawn(os.path.expanduser("~/bin/dmenu_session_manager")), desc="Open session manager (log out, restart, shutdown...)"),
    Key([mod, "control"], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout."),

    # Audio Controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 -q set Master 2dB+"), desc="Increase volume on default audio device (ALSA)"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 -q set Master 2dB-"), desc="Decrease volume on default audio device (ALSA)"),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle -q"), desc="Mute default audio device (ALSA)"),

    # Screen brightness
    Key([], 'XF86MonBrightnessUp',   lazy.spawn("urxvt -e light -A 10"), desc="Increase brightness"),
    Key([], 'XF86MonBrightnessDown', lazy.spawn("urxvt -e light -U 10"), desc="Decrease brightness"),

    # Screenshots
    Key([], 'Print', lazy.spawn(os.path.expanduser("~/bin/screenshot.sh")), desc="Take a full-screen screenshot. On multi-monitor systems, this will screenshot all monitors at once"),
    Key([mod], 'Print', lazy.spawn(os.path.expanduser("~/bin/screenshot_select.sh")), desc="Select an area to be screenshot using mouse")

]

groups = [Group(i) for i in "12345678"]

for i in groups:
    keys.extend([
        # mod + number for group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to worspace x"),

        # mod + shift + number for group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc="Move currently focused window to workspace x"),
    ])

layouts = [
    layout.MonadTall(align=0, border_width=0, border_focus='#ff0000', margin=10),
    layout.Max(),
]
floating_layout = layout.Floating()

@hook.subscribe.startup_once
def autostart():
    """Hook to load stuff when qtile starts, reads the config file below"""

    auto_start_file = os.path.expanduser('~/.config/qtile/autostart.sh')
    auto_start_file_wayland = os.path.expanduser('~/.config/qtile/autostart_wayland.sh')
    if (qtile.core.name == "x11"):
        if (os.path.isfile(auto_start_file) and os.access(auto_start_file, os.X_OK)):
            subprocess.Popen([auto_start_file])
        else:
            log.warning("X11 autostart file is not executable, or does not exist")
    elif (qtile.core.name == "wayland"):
        if (qtile.core.name == "wayland" and os.path.isfile(auto_start_file_wayland) and os.access(auto_start_file_wayland, os.X_OK)):
            subprocess.Popen([auto_start_file_wayland])
        else:
            log.warning("Wayland autostart file is not executable, or does not exist")
    else:
        log.error("Current backend cannot be established")

# Default font/settings for bar widgets.
widget_defaults = dict(
    font='Noto Sans',
    fontsize=12,
    padding=2,
)
# Default settings for extensions.
extension_defaults = widget_defaults.copy()
prompt = widget.Prompt(foreground='#00d2ff', prompt="Run: ")

if (num_screens == 2):  #If on desktop pc with dual monitors
    screens = [
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(inactive="#a9a9a9", active="#f3f4f5"),
                    prompt,
                    widget.WindowName(font="Noto Sans Bold"),
                    widget.TextBox(font="FontAwesome", text=" ", foreground="#44c419", padding=0, fontsize=20),
                    widget.TextBox(font="FontAwesome", text="", foreground="#44c419", padding=0, fontsize=20),
                    widget.Net(interface=None, format='{down} ↓↑ {up}'), # None = it will show traffic on all interfaces combined
                    widget.Sep(padding=10),
                    widget.KeyboardLayout(configured_keyboards=['it', 'dk', 'us'], font="Noto Sans Bold"),
                    widget.sep.Sep(padding=10),
                    widget.TextBox(font="FontAwesome", text="", foreground='#cd1f3f', padding=0, fontsize=20),
                    widget.CPUGraph(border_color='#c0c5ce',  fill_color='#6790eb', graph_color='#6790eb', border_width=1, line_width=1, core="all", type="box"),
                    widget.Sep(linewidth=0, padding=5),
                    widget.TextBox(font="FontAwesome", text="", foreground="#bc5a03", padding=0, fontsize=20),
                    widget.ThermalSensor(foreground_alert="#cd1f3f", metric=True, padding=3, threshold=80),
                    widget.Sep(padding=10),
                    widget.TextBox(font="FontAwesome", text="", foreground='#3384d0', padding=0, fontsize=20),
                    widget.Memory(format = '{MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}', update_interval=5, foreground='#f3f4f5'),
                    widget.sep.Sep(padding=10),
                    # widget.CurrentLayoutIcon(custom_icon_paths=['usr/lib/python3.11/site-packages/libqtile/resources/layout-icons']),
                    widget.CurrentLayoutIcon(),
                    widget.sep.Sep(padding=10),
                    StatusNotifier(),
                    PulseVolumeExtra(bar_width=40, limit_max_volume=True, step=5),
                    widget.sep.Sep(padding=10),
                    widget.TextBox(font="Font Awesome", text="", foreground="#fba922", padding=2, fontsize=20),
                    widget.Clock(format='%A %d-%m-%Y -- %H:%M'),
                ],
                24, background="#2F343F"  # Old background="#151515" # 24 is the height of the bar, followed by its color.
            ),
        ),
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(inactive="#a9a9a9", active="#f3f4f5"),
                    prompt,
                    widget.WindowName(font="Noto Sans Bold"),
                    widget.TextBox(font="FontAwesome", text=" ", foreground="#44c419", padding=0, fontsize=20),
                    widget.TextBox(font="FontAwesome", text="", foreground="#44c419", padding=0, fontsize=20),
                    widget.Net(interface=None, format='{down} ↓↑ {up}'), # None = it will show traffic on all interfaces combined
                    widget.Sep(padding=10),
                    widget.KeyboardLayout(configured_keyboards=['it', 'dk', 'us'], font="Noto Sans Bold"),
                    widget.sep.Sep(padding=10),
                    widget.TextBox(font="FontAwesome", text="", foreground='#cd1f3f', padding=0, fontsize=20),
                    widget.CPUGraph(border_color='#c0c5ce',  fill_color='#6790eb', graph_color='#6790eb', border_width=1, line_width=1, core="all", type="box"),
                    widget.Sep(linewidth=0, padding=5),
                    widget.TextBox(font="FontAwesome", text="", foreground="#bc5a03", padding=0, fontsize=20),
                    widget.ThermalSensor(foreground_alert="#cd1f3f", metric=True, padding=3, threshold=80),
                    widget.Sep(padding=10),
                    widget.TextBox(font="FontAwesome", text="", foreground='#3384d0', padding=0, fontsize=20),
                    widget.Memory(format = '{MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}', update_interval=5, foreground='#f3f4f5'),
                    widget.sep.Sep(padding=10),
                    #widget.CurrentLayoutIcon(custom_icon_paths=['usr/lib/python3.11/site-packages/libqtile/resources/layout-icons']),
                    widget.CurrentLayoutIcon(),
                    widget.sep.Sep(padding=10),
                    StatusNotifier(),
                    PulseVolumeExtra(bar_width=40, limit_max_volume=True, step=5),
                    widget.sep.Sep(padding=10),
                    widget.TextBox(font="Font Awesome", text="", foreground="#fba922", padding=2, fontsize=20),
                    widget.Clock(format='%A %d-%m-%Y -- %H:%M'),
                ],
                24, background="2F343F"  #Old background="#151515"
            )
        )
    ]
else:
    screens = [      #If on laptop
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(inactive="#a9a9a9", active="#f3f4f5"),
                    prompt,
                    widget.WindowName(font="Noto Sans Bold"),
                    widget.TextBox(font="FontAwesome", text=" ", foreground="#44c419", padding=0, fontsize=30),
                    widget.TextBox(font="FontAwesome", text="", foreground="#44c419", padding=0, fontsize=30),
                    widget.Net(interface=None, format='{down} ↓↑ {up}'), # None = it will show traffic on all interfaces combined
                    widget.Sep(padding=10),
                    widget.KeyboardLayout(configured_keyboards=['it', 'dk', 'us'], font="Noto Sans Bold"),
                    widget.sep.Sep(padding=10),
                    widget.TextBox(font="FontAwesome", text="", foreground='#cd1f3f', padding=0, fontsize=32),
                    widget.CPUGraph(border_color='#c0c5ce',  fill_color='#6790eb', graph_color='#6790eb', border_width=1, line_width=1, core="all", type="box"),
                    widget.Sep(linewidth=0, padding=5),
                    widget.TextBox(font="FontAwesome", text="", foreground="#bc5a03", padding=0, fontsize=20),
                    widget.ThermalSensor(foreground_alert="#cd1f3f", metric=True, padding=3, threshold=80),
                    widget.Sep(padding=10),
                    widget.TextBox(font="FontAwesome", text="", foreground='#3384d0', padding=0, fontsize=32),
                    widget.Memory(format = '{MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}', update_interval=5, foreground='#f3f4f5'),
                    widget.sep.Sep(padding=10),
                    widget.CurrentLayoutIcon(),
                    widget.sep.Sep(padding=10),
                    StatusNotifier(),
                    PulseVolumeExtra(bar_width=40, limit_max_volume=True, step=5),
                    widget.sep.Sep(padding=10),
                    widget.TextBox(font="Font Awesome", text="", foreground="#fba922", padding=2, fontsize=32),
                    widget.Clock(format='%A %d-%m-%Y -- %I:%M %p'),
                ],
                24, background="#2F343F"  #Old background="#151515"
            ),
        ),
        Screen(),
   ]
# Mouse controls for floating windows:
# - mod + left click: move window around by dragging
# - mod + right click: resize window by dragging
# - mod + middle mouse click: bring selected floating window to front.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# main = None
floating_layout = layout.Floating(
    float_rules=[
         # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        # Match(title="GitKraken"),
        Match(wm_class="gnome-calculator"),
        # Match(title="Discord Updater"),
    ]
)

# If a window requests to be fullscreen, it is automatically fullscreened.
# Set this to false if you only want windows to be fullscreen if you ask them to be.
auto_fullscreen = True

# If things like steam games want to auto-minimize themselves when losing focus, should we respect this or not?
auto_minimize = True

# When clicked, should the window be brought to the front or not.
bring_front_click = False

# If true, the cursor follows the focus as directed by the keyboard, warping to the center of the focused window.
# When switching focus between screens, If there are no windows in the screen, the cursor will warp to the center of the screen.
cursor_warp = False

# A function which generates group binding hotkeys.
# It takes a single argument, the DGroups object, and can use that to set up dynamic key bindings.
dgroups_key_binder = None

# A list of Rule objects which can send windows to various groups based on matching criteria.
dgroups_app_rules = []

# Behavior of the _NET_ACTIVATE_WINDOW message sent by applications
#     - urgent: urgent flag is set for the window
#     - focus: automatically focus the window
#     - smart: automatically focus if the window is in the current group
#     - never: never automatically focus any window that requests it
focus_on_window_activation = "smart"

# Controls whether or not focus follows the mouse around as it moves across windows in a layout.
follow_mouse_focus = True

# Controls whether or not to automatically reconfigure screens when there are changes in randr output configuration.
reconfigure_screens = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "Qtile"

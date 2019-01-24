 # Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
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


from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

from typing import List
import os
import subprocess

mod = "mod4"

##-----KEYBINDS------
keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down()),
    Key([mod], "j", lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down()),
    Key([mod, "control"], "j", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("urxvt")),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
    Key([mod, "shift"], 'r', lazy.spawn("dmenu_run -b -fn 'Monospace:size=10' -nb '#000000' -nf '#fefefe'")),
    
    #Audio Controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 -q set Master 2dB+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 -q set Master 2dB-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle -q")),

    #lock, suspend and such
    Key([mod, "control"], "l", lazy.spawn("xscreensaver-command -lock")),

    #Screenshots
    #Key([], 'Print', lazy.spawn("~/bin/screenshot.sh")),
    #Key([mod], 'Print', lazy.spawn("~/bin/screenshot_select.sh")),
    
    #Monad Default Bindings
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "plus", lazy.layout.grow()),
    Key([mod, "shift"], "minus", lazy.layout.shrink()),
    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod, "shift"], "m", lazy.layout.maximize()),
    Key([mod, "shift"], "space", lazy.layout.flip()),

    #Programs
    Key([mod], "g", lazy.spawn("chromium-browser")),
    Key([mod], "f", lazy.spawn("pcmanfm")),
    Key([mod], "m", lazy.spawn("urxvt -e cmus")),
]

groups = [Group(i) for i in "12345678"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layouts = [
    layout.MonadTall(align='MonadTail._right', border_focus='#ff0000', margin=10),
    layout.Max(),
    #layout.Tile(ratio=0.5, masterWindows=2),
    layout.TreeTab(margin=10),
    #layout.Stack(num_stacks=2)
]

@hook.subscribe.startup_once
def autostart():
    home =os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(foreground='#00d2ff', prompt="Run: "),
                widget.WindowName(),
                widget.Notify(),
                widget.CPUGraph(fill_color='#fff400', graph_color='#ce0202', line_width=2),
                widget.Memory(update_interval=30),
                widget.sep.Sep(padding=2),
                widget.CurrentLayoutIcon(custom_icon_paths=['/usr/local/src/qtile/qtile/libqtile/resources/layout-icons']),
                #widget.sep.Sep(padding=2),
                #widget.TextBox("C", foreground='#00ff38', name="custom"),
                widget.sep.Sep(padding=2),
                widget.BatteryIcon(theme_path='/home/elendil/.icons/AwOkenWhite/clear/24x24/status'),
                widget.Battery(foreground='#0cdb63', low_percentage=0.20, low_foreground='fa5e5b', update_delay=10, format='{percent:.0%}'),
                widget.sep.Sep(padding=2),
                widget.Volume(theme_path='/home/elendil/.icons/AwOkenWhite/clear/24x24/status'),
                # mute_command='amixer -D pulse -q sset Master toggle'
                widget.sep.Sep(padding=2),
                widget.Systray(),
                #widget.Volume(),
                widget.sep.Sep(padding=2),
                widget.Clock(format='%A %d-%m-%Y -- %I:%M %p'),
            ],
            24,
        ),
    ),
]

# Drag floating layouts. #                widget.BatteryIcon(theme_path='/usr/local/src/qtile/qtile/libqtile/resources/battery-icons'),
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.client_new
def set_floating(window):
    if ((window.window.get_name() == 'gitkraken') or
         (window.window.get_name() == 'keepass2')):
        window.floating = True

@hook.subscribe.client_new
def floating_dialogs(window):
    dialog = window.window.get_wm_type() == 'dialog'
    transient = window.window.get_wm_transient_for()
    if dialog or transient:
        window.floating = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

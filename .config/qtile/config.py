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
#TEST

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook, extension 
from typing import List
import os, shlex, subprocess, platform

mod = "mod4"

hostname = platform.node()
num_screens = {
    'mint-tower': 2,
    'ThinkPad-E480': 1
} 


##-----KEYBINDS------
keys = [
    #MonadTall Bindings
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "space", lazy.layout.next()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "plus", lazy.layout.grow()),
    Key([mod, "shift"], "minus", lazy.layout.shrink()),
    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod, "shift"], "m", lazy.layout.maximize()),
    Key([mod, "shift"], "space", lazy.layout.flip()),

    # Toggle between different layouts
    Key([mod], "Tab", lazy.next_layout()),
   
    #Floating Layout Keybinds
    Key([mod], "t", lazy.window.enable_floating()),
    Key([mod, "shift"], "t", lazy.window.disable_floating()),
    
    #Window controls (layout agnostic)
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
    Key([mod, "shift"], 'r', lazy.spawn("dmenu_run -b -fn 'Monospace:size=10' -nb '#000000' -nf '#fefefe'")),
    Key([mod, "control"], "l", lazy.spawn("xscreensaver-command -lock")),   #lock the screen

    #Programs
    Key([mod], "Return", lazy.spawn("urxvt")),
    Key([mod], "g", lazy.spawn("chromium-browser")),
    Key([mod], "f", lazy.spawn("urxvt -e ranger")),
    Key([mod], "m", lazy.spawn("urxvt -e cmus")),
    #Audio Controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 -q set Master 2dB+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 -q set Master 2dB-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle -q")),
    #Screenshots
    Key([], 'Print', lazy.spawn("/home/elendil/bin/screenshot.sh")),
    Key([mod], 'Print', lazy.spawn("/home/elendil/bin/screenshot_select.sh")),

    #Screen brightness (Coming soon)
    Key([], 'XF86MonBrightnessUp',   lazy.spawn("/home/elendil/bin/brightness_up.sh")),
    Key([], 'XF86MonBrightnessDown', lazy.spawn("/home/elendil/bin/brightness_down.sh"))

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
floating_layout = layout.Floating()

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

if (num_screens[hostname] == 2):  #If on desktop pc with dueal screens
    screens = [
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(),
                    widget.Prompt(foreground='#00d2ff', prompt="Run: "),
                    widget.WindowName(),
                    widget.Notify(default_timeout=5),
                    widget.CPUGraph(fill_color='#fff400', graph_color='#ce0202', line_width=2),
                    widget.Memory(update_interval=30),
                    widget.sep.Sep(padding=2),
                    widget.CurrentLayoutIcon(custom_icon_paths=['/usr/local/src/qtile/qtile/libqtile/resources/layout-icons']),
                    widget.sep.Sep(padding=2),
                    widget.Volume(theme_path='/home/elendil/.icons/AwOkenWhite/clear/24x24/status'),
                    widget.sep.Sep(padding=2),
                    widget.Systray(),
                    widget.sep.Sep(padding=2),
                    widget.Clock(format='%A %d-%m-%Y -- %I:%M %p'),
                ],
                24,
            ),
        ),
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(),
                    widget.Prompt(foreground='#00d2ff', prompt="Run: "),
                    widget.WindowName(),
                    widget.Notify(default_timeout=5),
                    widget.CurrentLayoutIcon(custom_icon_paths=['/usr/local/src/qtile/qtile/libqtile/resources/layout-icons']),
                    widget.sep.Sep(padding=2),
                    widget.Clock(format='%A %d-%m-%Y -- %I:%M %p'),   
                ],
                24,
            )
        )
    ]
else:
   screens = [      #If on laptop
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(),
                    widget.Prompt(foreground='#00d2ff', prompt="Run: "),
                    widget.WindowName(),
                    widget.Notify(default_timeout=5),
                    widget.Net(interface='wlp5s0'),
                    widget.CPUGraph(fill_color='#fff400', graph_color='#ce0202', line_width=2),
                    widget.Memory(update_interval=30),
                    widget.sep.Sep(padding=2),
                    widget.CurrentLayoutIcon(custom_icon_paths=['/usr/local/src/qtile/qtile/libqtile/resources/layout-icons']),
                    widget.sep.Sep(padding=2),
                    widget.BatteryIcon(theme_path='/home/elendil/.icons/AwOkenWhite/clear/24x24/status'),
                    widget.Battery(foreground='#0cdb63', low_percentage=0.20, low_foreground='fa5e5b', update_delay=10, format='{percent:.0%}'),
                    widget.sep.Sep(padding=2),
                    widget.Volume(theme_path='/home/elendil/.icons/AwOkenWhite/clear/24x24/status'),
                    widget.sep.Sep(padding=2),
                    widget.Systray(),
                    widget.sep.Sep(padding=2),
                    widget.Clock(format='%A %d-%m-%Y -- %I:%M %p'),
                ],
                24,
            ),
        ),
        Screen(),
   ]         

# Drag floating layouts.
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
#wmname = "LG3D"
wmname = "Qtile"

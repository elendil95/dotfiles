
"""Wrapper class for Xlib python bindings."""


class X11Display:

    def __init__(self, display, screen, root):
        self.display = display
        self.screen = screen
        self.root = root

# pylint: disable=missing-function-docstring
    def get_monitor_info(self, output, res):
        return self.display.xrandr_get_output_info(output, res['config_timestamp'])._data

    def get_screen_resources(self):
        return self.root.xrandr_get_screen_resources()._data
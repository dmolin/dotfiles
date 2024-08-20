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

import asyncio
import os
import subprocess

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import (
    Click,
    Drag,
    DropDown,
    EzKey,
    Group,
    Key,
    KeyChord,
    Match,
    ScratchPad,
    Screen,
)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification

from tabbed import Tabbed

mod = "mod4"
alt = "mod1"
# terminal = guess_terminal()
# terminal = "kitty -o background-opacity=0.95"
terminal = "kitty"


# utility functions
@lazy.function
def float_to_front(qtile) -> None:
    """Bring all floating windows of the group to front"""
    for window in qtile.current_group.windows:
        if window.floating:
            window.cmd_bring_to_front()


def toggle_focus_floating():
    """Toggle focus between floating window and other windows in group"""

    @lazy.function
    def _toggle_focus_floating(qtile):
        group = qtile.current_group
        switch = "non-float" if qtile.current_window.floating else "float"

        for win in reversed(group.focus_history):
            if switch == "float" and win.floating:
                # win.focus(warp=False)
                group.focus(win)
                win.cmd_bring_to_front()
                return
            if switch == "non-float" and not win.floating:
                # win.focus(warp=False)
                group.focus(win)
                return

    return _toggle_focus_floating


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "shift"],
        "right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "mod1"], "left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "mod1"],
        "right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key([mod, "mod1"], "down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "mod1"], "up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod, "control"], "space", lazy.next_layout(), desc="Toggle between layouts"),
    # Key([mod], "Tab", float_to_front(), desc="Toggle between floating/docked windows"),
    Key(
        [mod],
        "Tab",
        toggle_focus_floating(),
        desc="Toggle between floating/docked windows",
    ),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod],
        "r",
        lazy.window.toggle_floating(),
        desc="Toggle window floating/docked state",
    ),
    Key([mod], "f", lazy.window.toggle_maximize()),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen()),
    # Applications
    Key([mod], "space", lazy.spawn("rofi -modi drun -show drun"), desc="Show ROFI"),
    Key(
        [mod, "shift"],
        "space",
        lazy.spawn("rofi -show window"),
        desc="Show opened programs",
    ),
    KeyChord(
        [mod],
        "w",
        [
            Key([], "t", lazy.spawn("thorium-browser")),
            Key([], "c", lazy.spawn("chromium")),
            Key([], "w", lazy.spawn("/home/user/bin/WebStorm/bin/webstorm.sh")),
            Key([], "v", lazy.spawn("vivaldi")),
        ],
    ),
    Key([], "XF86AudioMute", lazy.spawn("/home/user/.config/qtile/volume-toggle.sh")),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("/home/user/.config/qtile/volume-set.sh 2%+"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("/home/user/.config/qtile/volume-set.sh 2%-"),
    ),
    Key([], "Pause", lazy.spawn("/home/user/.config/qtile/volume-set.sh 2%+")),
    Key([], "Scroll_Lock", lazy.spawn("/home/user/.config/qtile/volume-set.sh 2%-")),
    Key([alt], "Page_Up", lazy.spawn("/home/user/.config/qtile/volume-set.sh 2%+")),
    Key(
        [alt],
        "Page_Down",
        lazy.spawn("/home/user/.config/qtile/volume-set.sh 2%-"),
    ),
    # Key([], "Pause", lazy.spawn("amixer set Master 2%+ && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)")),
    # Key([], "Scroll_Lock", lazy.spawn("amixer set Master 2%- && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)")),
    Key([], "Print", lazy.spawn("flameshot gui -c -p /home/user/Pictures")),
    Key(["control"], "Print", lazy.spawn("flameshot screen")),
    Key([mod], "BackSpace", lazy.spawn("/home/user/.config/rofi/scripts/powermenu.sh")),
    Key([mod], "backslash", lazy.next_screen(), desc="Move focus to the next display"),
    Key(
        [mod],
        "F2",
        lazy.spawn("terminator --geometry 1600x1000 --role pop-up -e ranger"),
    ),
    Key([mod], "F3", lazy.spawn("pcmanfm-qt")),
    Key([mod], "F6", lazy.spawn("tuxedo-control-center")),
    Key([mod], "F9", lazy.spawn("/home/user/.config/qtile/toggle-headphones.sh")),
    # Key([mod], "F11", lazy.spawn("/home/user/.config/qtile/internal.sh")),
    Key([mod], "F12", lazy.spawn("/home/user/.config/qtile/external.sh")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
    EzKey("M-h", lazy.layout.left()),
    EzKey("M-l", lazy.layout.right()),
    EzKey("M-j", lazy.layout.down()),
    EzKey("M-k", lazy.layout.up()),
]

layoutConfig = {
    # "border_focus_stack": ["#d75f5f", "#8f3d3d"],
    "border_focus": "#FA830E",
    "border_focus_stack": "#FA830E",
    "border_normal": "#413939",
    "border_width": 3,
    "margin": 5,
}

tabbedConfig = {
    "hspace": 1,
    "margin": 5,
    "border_width": 3,
    "border_focus": "#FA830E",
    "border_normal": "#413939",
    "active_bg": "#D4700D",
}

layouts = [
    layout.Columns(**layoutConfig),
    Tabbed(**tabbedConfig),
    # Bonsai(**{"window_border-size": 1, "tab_bar_height": 20}),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Max(**layoutConfig),
    # layout.Zoomy(),
    # layout.TreeTab(),
]

widget_defaults = dict(
    # font="sans",
    # font="NotoSansMono Nerd Font",
    font="JetBrains Mono Bold",
    fontsize=14,
    padding=5,
)
extension_defaults = widget_defaults.copy()


def Separator():
    return widget.Image(filename="~/.config/qtile/assets/2.png")


commonWidgets = [
    # widget.TextBox("default config", name="default"),
    # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
    # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
    # widget.StatusNotifier(),
    # Separator(),
    widget.Net(
        format="{down:3.0f}{down_suffix} ↓↑ {up:3.0f}{up_suffix}",
        width=140,
        scroll=True,
        scroll_fixed_width=True,
    ),
    # Separator(),
    widget.OpenWeather(
        format="{main_temp} °{units_temperature} {weather_details} {icon}",
        app_key=os.environ.get("OPENWEATHER_APIKEY"),
        coordinates={"latitude": "51.267748", "longitude": "1.061893"},
        padding_right=20,
    ),
    widget.Spacer(length=10),
    # Separator(),
    # widget.CPU(),
    # widget.Sep(),
    # widget.Bluetooth(),
    # widget.Sep(),
    widget.BatteryIcon(
        theme_path="~/.config/qtile/icons/battery-icons",
        border_width=4,
    ),
    widget.Battery(
        padding=6,
        full_char="",
        notify_below=10,
        low_foreground="FFFF00",
        low_percentage=0.1,
    ),
    widget.Image(filename="~/.config/qtile/assets/5.png"),
    widget.Clock(background="#282738", format="<b>%Y-%m-%d %a %H:%M:%S</b>"),
    # widget.Volume(),
    # widget.Sep()
]

screens = [
    # Main screen
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    background="#282738",
                    highlight_method="block",
                    this_screen_border="606060",
                    this_current_screen_border="FA830E",
                    other_screen_border="606060",
                    other_current_screen_border="404060",
                ),
                widget.Image(
                    filename="~/.config/qtile/assets/6.png",
                ),
                widget.Image(filename="~/.config/qtile/assets/layout.png"),
                widget.CurrentLayout(
                    font="JetBrains Mono Bold",
                ),
                # widget.Image(
                # filename='~/.config/qtile/assets/1.png',
                # ),
                # widget.Spacer(),
                widget.WindowName(
                    fmt="[{}]",
                ),
                # widget.Chord(
                # chords_colors={
                # "launch": ("#ff0000", "#ffffff"),
                # },
                # name_transform=lambda name: name.upper(),
                # ),
                *commonWidgets,
                widget.Systray(background="#282738"),
                # widget.QuickExit(),
            ],
            28,
            # opacity=0.8,
            # background='#282738',
            background="#353446",
            margin=0,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
            border_width=2,
            border_color="#353446",
        ),
    ),
    # Secondary
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    background="#282738",
                    highlight_method="block",
                    this_screen_border="606060",
                    this_current_screen_border="FA830E",
                    other_screen_border="606060",
                    other_current_screen_border="404060",
                ),
                widget.Image(
                    filename="~/.config/qtile/assets/6.png",
                ),
                widget.Image(filename="~/.config/qtile/assets/layout.png"),
                widget.CurrentLayout(
                    font="JetBrains Mono Bold",
                ),
                widget.WindowName(
                    fmt="[{}]",
                ),
                *commonWidgets,
            ],
            28,
            background="#353446",
            margin=0,
            border_width=2,
            border_color="#353446",
        ),
    ),
    # Tertiary
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    background="#282738",
                    highlight_method="block",
                    this_screen_border="606060",
                    this_current_screen_border="FA830E",
                    other_screen_border="606060",
                    other_current_screen_border="404060",
                ),
                widget.Image(
                    filename="~/.config/qtile/assets/6.png",
                ),
                widget.Image(filename="~/.config/qtile/assets/layout.png"),
                widget.CurrentLayout(
                    font="JetBrains Mono Bold",
                ),
                widget.WindowName(
                    fmt="[{}]",
                ),
                *commonWidgets,
            ],
            28,
            background="#353446",
            margin=0,
            border_width=2,
            border_color="#353446",
        ),
    ),
]

groups = [Group(i) for i in "1234567890"]

if len(screens) == 3:
    for i in groups:
        keys.extend(
            [
                # Switch to group N
                Key(
                    [mod],
                    i.name,
                    (
                        lazy.to_screen(0)
                        if i.name in "123456"
                        else lazy.to_screen(2) if i.name in "789" else lazy.to_screen(1)
                    ),
                    lazy.group[i.name].toscreen(),
                ),
                # Move window to group N
                Key(
                    [mod, "shift"],
                    i.name,
                    lazy.window.togroup(i.name, switch_group=False),
                    (
                        lazy.to_screen(0)
                        if i.name in "123456"
                        else lazy.to_screen(2) if i.name in "789" else lazy.to_screen(1)
                    ),
                    lazy.group[i.name].toscreen(),
                ),
            ]
        )
else:
    for i in groups:
        keys.extend(
            [
                # Switch to group N
                Key([mod], i.name, lazy.group[i.name].toscreen()),
                # Move window to group N
                Key(
                    [mod, "shift"],
                    i.name,
                    lazy.window.togroup(i.name, switch_group=True),
                ),
            ]
        )

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                # "term", "terminator", width=0.7, height=0.7, x=0.15, y=0.15, opacity=1
                "term", "kitty", width=0.7, height=0.7, x=0.15, y=0.15, opacity=1
            ),
        ],
    )
)
keys.extend(
    [Key(["control"], "grave", lazy.group["scratchpad"].dropdown_toggle("term"))]
)

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
# cursor_warp = False
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(role="pop-up"),
        Match(wm_class="pop-up"),
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="GParted"),
        Match(wm_class="Lightdm-settings"),
        Match(wm_class="Manjaro Settings Manager"),
        Match(wm_class="Pamac-manager"),
        Match(wm_class="pamac-manager"),
        Match(wm_class="qt5ct"),
        Match(wm_class="Qtconfig-qt4"),
        Match(wm_class="VirtualBox Manager"),
        Match(wm_class="VirtualBoxVM"),
        Match(wm_class="Gnome-disks"),
        Match(wm_class="gnome-calendar"),
        Match(wm_class="pcmanfm-qt", role="pop-up"),
        Match(title="PayPal Checkout"),
        Match(wm_class="SpeedCrunch"),
        Match(wm_class="Nm-connection-editor"),
        Match(wm_class="Steam"),
        Match(wm_class="Blueman-manager"),
        Match(wm_class="Cypress"),
        Match(wm_class="zoom"),
        Match(title="int_test - Chromium"),
        Match(title="win0"),
        Match(title="Event Tester"),
        Match(wm_class="tuxedo-control-center"),
        Match(wm_instance_class="pcloud"),
        Match(wm_class="hp-toolbox"),
        Match(wm_class="pavucontrol"),
        Match(title="Preferences"),
        Match(wm_type="utility"),
        Match(wm_type="notification"),
        Match(wm_type="confirm"),
        Match(wm_type="splash"),
        Match(wm_type="dialog"),
        Match(wm_type="toolbar"),
        Match(wm_type="file_progress"),
        Match(title="Cryptomator"),
        Match(wm_class="org.cryptomator.launcher.Cryptomator$MainApp"),
        Match(wm_class="com.github.tchx84.Flatseal"),
        Match(func=lambda c: c.has_fixed_size()),
        Match(func=lambda c: c.has_fixed_ratio()),
        Match(func=lambda c: bool(c.is_transient_for())),
    ],
    border_focus="#FA830E",
    border_width=3,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


# autostart apps
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])


@hook.subscribe.client_new
def dialogs(window):
    if window.window.get_wm_type() == "dialog" or window.window.get_wm_transient_for():
        window.floating = True


@hook.subscribe.client_new
def open_in_workspace(client):
    if client.name == "Slack":
        client.togroup("8")
    elif client.name == "NoSQLBooster for MongoDB":
        client.togroup("4")
    elif client.name == "telegram-desktop":
        client.togroup("8")


# this fixes the bug where some apps opens modal windows in the background instead of the front
@hook.subscribe.client_managed
async def restack_polkit(client):
    if "polkit-kde-authentication-agent-1" in client.get_wm_class():
        await asyncio.sleep(0.1)
        client.bring_to_front()

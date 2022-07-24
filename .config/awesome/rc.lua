-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

gears = require("gears")
awful = require("awful")
require("awful.autofocus")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
theme = gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua"
beautiful.init(theme)
-- beautiful.useless_gap = 5
beautiful.taglist_shape = gears.shape.rectangle;

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

require("includes/errors")
require("includes/layouts")
require("includes/wibar")
require("includes/keys")
require("includes/rules")
require("includes/signals")
require("includes/autostart")

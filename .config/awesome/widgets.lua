local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")

local widgets = {}

-- datetime 
widgets.datetime = wibox.widget.textbox()
vicious.register(widgets.datetime, vicious.widgets.date, "%b %d, %T", 1)

widgets.battery = wibox.widget.progressbar()
-- Register battery widget
vicious.register(widgets.battery, vicious.widgets.bat, "$2", 61, "BAT0")

return widgets
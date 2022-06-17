local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")

local widgets = {}

-- datetime 
widgets.datetime = wibox.widget.textbox()
vicious.register(widgets.datetime, vicious.widgets.date, "%b %d, %T", 1)

return widgets
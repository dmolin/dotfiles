local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")

local widgets = {}

-- datetime 
local datetime = wibox.widget.textbox()
vicious.register(datetime, vicious.widgets.date, "<span color='#FFFFFF'>%b %d, %T</span>", 1)

return datetime

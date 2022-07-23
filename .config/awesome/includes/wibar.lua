BASE_DIR = gears.filesystem.get_configuration_dir()

local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local datetime = require("widgets.datetime");

mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
          "request::activate",
          "tasklist",
          {raise = true}
      )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
       awful.button({ }, 1, function () awful.layout.inc( 1) end),
       awful.button({ }, 3, function () awful.layout.inc(-1) end),
       awful.button({ }, 4, function () awful.layout.inc( 1) end),
       awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      --filter  = awful.widget.taglist.filter.all,
      filter  = awful.widget.taglist.filter.noempty,
      buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      --filter  = awful.widget.tasklist.filter.focused,
      buttons = tasklist_buttons,
      style = {
        bg_focus = beautiful.bg_normal
      }
    }

    -- Create wibox with batwidget (not used)
    --_batbox = wibox.layout.margin(
        --wibox.widget{ { max_value = 1, widget = widgets.battery,
                        --border_width = 0.5, border_color = "#000000",
                        --color = { type = "linear",
                                  --from = { 0, 0 },
                                  --to = { 0, 30 },
                                  --stops = { { 0, "#AECF96" },
                                            --{ 1, "#FF5656" } } } },
                      --forced_height = 10, forced_width = 8,
                      --direction = 'east', color = beautiful.fg_widget,
                      --layout = wibox.container.rotate },
        --3, 3, 3, 3)
    battery_args = {}
    battery_args.show_current_level = true
    battery_args.path_to_icons = BASE_DIR .. "icons/status/symbolic/"

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = beautiful.bg_wibar })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            wibox.layout.margin(s.mytaglist, 3, 3, 0, 0),
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            net_speed_widget(),
            wibox.layout.margin(
              weather_widget({
                api_key='0fa78e5d530e2b3382b022f0c850f777',
                coordinates = {51.503176, -0.038303},
                show_hourly_forecast = true,
                show_daily_forecast = true,
                timeout = 600
              }),
              3, 3, 0, 0),
            wibox.layout.margin(volume_widget(), 3, 3, 0, 0),
            wibox.layout.margin(battery_widget(battery_args), 3, 3, 0, 0),
            -- mykeyboardlayout,
            wibox.layout.margin(wibox.widget.systray(), 3, 3, 3, 3),
            -- margins: left, right, top, bottom
            wibox.layout.margin(datetime, 5, 5, 0, 0)
        },
    }
end)
-- }}}

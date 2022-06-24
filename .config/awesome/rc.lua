-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local widgets = require("widgets")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local BASE_DIR = gears.filesystem.get_configuration_dir()

local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

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

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
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

    -- Create wibox with batwidget
    batbox = wibox.layout.margin(
        wibox.widget{ { max_value = 1, widget = widgets.battery,
                        border_width = 0.5, border_color = "#000000",
                        color = { type = "linear",
                                  from = { 0, 0 },
                                  to = { 0, 30 },
                                  stops = { { 0, "#AECF96" },
                                            { 1, "#FF5656" } } } },
                      forced_height = 10, forced_width = 8,
                      direction = 'east', color = beautiful.fg_widget,
                      layout = wibox.container.rotate },
        3, 3, 3, 3)
    battery_args = {}
    battery_args.show_current_level = true
    battery_args.path_to_icons = BASE_DIR .. "icons/status/symbolic/"

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

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
                api_key='b0d0f4cd245abb1f1c53bb42ab80be67',
                coordinates = {51.503176, -0.038303},
                show_hourly_forecast = true,
                show_daily_forecast = true
              }),
              3, 3, 0, 0),
            wibox.layout.margin(volume_widget(), 3, 3, 0, 0),
            wibox.layout.margin(battery_widget(battery_args), 3, 3, 0, 0),
            -- mykeyboardlayout,
            wibox.layout.margin(wibox.widget.systray(), 3, 3, 3, 3),
            -- margins: left, right, top, bottom
            wibox.layout.margin(widgets.datetime, 5, 5, 0, 0)
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, "`", function () awful.spawn("rofi -modi drun -show drun") end, 
      { description = "run rofi", group="awesome" }),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
      {description="show help", group="awesome"}),
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              --{description = "view previous", group = "tag"}),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              --{description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
      {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "Right",
      function ()
          awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Left",
      function ()
          awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
    ),

    -- Audio/Video general shortcuts
    awful.key({ modkey, }, "Pause", function () awful.spawn.with_shell("amixer set Master 2%+ && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)") end, { description = "increase volume" }),
    awful.key({ modkey, }, "Scroll_Lock", function () awful.spawn.with_shell("amixer set Master 2%- && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)") end, { description = "decrease volume" }),
    awful.key({ modkey, }, "F6", function () awful.spawn.with_shell("amixer set Master 2%+ && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)") end, { description = "increase volume" }),
    awful.key({ modkey, }, "F5", function () awful.spawn.with_shell("amixer set Master 2%- && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)") end, { description = "decrease volume" }),
    --awful.key({ modkey, }, "#51", function () awful.spawn.with_shell("betterlockscreen -l") end),
    awful.key({ }, "Print", function () awful.spawn.with_shell("flameshot gui -c -p ~/Pictures") end),
    awful.key({ modkey,  }, "Print", function () awful.spawn.with_shell("flameshot screen -n 1 -c -p ~/Pictures") end),
    awful.key({ modkey, }, "BackSpace", function () awful.spawn.with_shell("~/.config/rofi/scripts/powermenu.sh") end),

    ------------------------
    -- Layout manipulation
    ------------------------
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx(  1)    end,
      {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx( -1)    end,
      {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey }, "\\", function () awful.screen.focus_relative( 1) end,
      {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey }, "]", function () awful.screen.focus_relative( 1) end,
      {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey }, "[", function () awful.screen.focus_relative(-1) end,
      {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
      {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
      {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,    }, "=",     function () awful.tag.incnmaster( 1, nil, true) end,
      {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey,    }, "-",     function () awful.tag.incnmaster(-1, nil, true) end,
      {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
      {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
      {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
      {description = "select next", group = "layout"}),
    awful.key({ modkey, "Mod1"   }, "space", function () awful.layout.inc(-1)                end,
      {description = "select previous", group = "layout"}),

    awful.key({ modkey,           }, "Tab",
      function ()
          awful.client.focus.history.previous()
          if client.focus then
              client.focus:raise()
          end
      end,
      {description = "go back", group = "client"}),

    -- Standard program
    
    -- file managers
    awful.key({ modkey, }, "F2", function () awful.spawn.with_shell("terminator --geometry 1600x1000 --role pop-up -e ranger") end),
    awful.key({ modkey, }, "F3", function () awful.spawn.with_shell("pcmanfm-qt") end),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
      {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
      {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
      {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Control" }, "n",
      function ()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
          end
      end,
      {description = "restore minimized", group = "client"}),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
      {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
      function (c)
          c.fullscreen = not c.fullscreen
          c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "q",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
    awful.key({ modkey, }, "r",  awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
    awful.key({ modkey, "Shift" }, "\\",      function (c) c:move_to_screen()               end,
      {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
    --awful.key({ modkey, "Shift"     }, "]",      function (c) c:move_to_screen()  end,
      --{description = "move to right screen", group = "client"}),
    --awful.key({ modkey, "Shift"     }, "[",      function (c) c:move_to_screen(screen:get_next_in_direction(c.screen, "left"))   end,
      --{description = "move to left screen", group = "client"}),
    awful.key({ modkey,           }, "n",
      function (c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
		awful.key({ modkey, }, "m", 
			function (c)
				awful.layout.set(awful.layout.suit.max)
			end,
			{ description = "Switch to Maximized layout", group = "layout" }),
    awful.key({ modkey, "Shift" }, "m",
      function (c)
          c.maximized = not c.maximized
          c:raise()
      end ,
      {description = "(un)maximize", group = "client"})
    --awful.key({ modkey, "Control" }, "m",
      --function (c)
          --c.maximized_vertical = not c.maximized_vertical
          --c:raise()
      --end ,
      --{description = "(un)maximize vertically", group = "client"}),
    --awful.key({ modkey, "Shift"   }, "m",
      --function (c)
          --c.maximized_horizontal = not c.maximized_horizontal
          --c:raise()
      --end ,
      --{description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "VirtualBox Manager",
          "Manjaro Settings Manager",
          "alsamixer",
          "Lxappearance",
          "Pamac-manager",
          "Pavucontrol",
          "qt5ct",
          "Skype",
          "GParted",
          "Cypress",
          "SpeedCrunch",
          "qemu-system-x86_64",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
	        "int_test - Chromium",
	        "win0",
	        "Firewall"
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
	        "scratchpad"
        }
      }, properties = { 
        floating = true,
	placement = awful.placement.centered
      }},

    -- Add titlebars to normal clients and dialogs
    --{ rule_any = {type = { "normal", "dialog" }
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", 
  function(c) 
    c.border_color = beautiful.border_focus 
    c.border_width = dpi(2)
  end)
client.connect_signal("unfocus", 
  function(c) 
    c.border_color = beautiful.border_normal 
    c.border_width = dpi(1)
  end)
-- }}}

-- Autostart applications

awful.spawn.with_shell("volnoti -a 0.9")
awful.spawn.with_shell("~/.config/picom/start_picom.sh")
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
awful.spawn.with_shell("xfce4-power-manager")
awful.spawn.with_shell("pamac-tray")
--awful.spawn.with_shell("conky &")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("xautolock -time 40 -locker blurlock")
awful.spawn.with_shell("fix_cursor")
awful.spawn.with_shell("~/.config/awesome/post-start.sh")
awful.spawn.with_shell("wmname LG3D")

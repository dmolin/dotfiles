modkey = "Mod4"

menubar.utils.terminal = terminal

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, "d", function () awful.spawn("rofi -modi drun -show drun") end, 
      { description = "run rofi", group="awesome" }),
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
    awful.key({ modkey, "Mod1" }, "Right", function () awful.screen.focus_relative( 1) end,
      {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Mod1" }, "Left", function () awful.screen.focus_relative(-1) end,
      {description = "focus the previous screen", group = "screen"}),
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
    awful.key({ modkey, }, "m", 
      function ()
        awful.layout.set(awful.layout.suit.max)
      end,
      { description = "Switch to Maximized layout", group = "layout" }),
    awful.key({ modkey, }, "e", 
      function ()
        awful.layout.set(awful.layout.suit.tile)
      end,
      { description = "Switch to Tiled layout", group = "layout" }),
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
      {description = "restore minimized", group = "client"})

    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end,
    --  {description = "show the menubar", group = "launcher"})
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
    awful.key({ modkey, "Shift" }, "m",
      function (c)
          c.maximized = not c.maximized
          c:raise()
      end ,
      {description = "(un)maximize", group = "client"}),
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
    awful.key({ modkey }, "p", function (c) bling.module.tabbed.pick() end, { description = "add a client to a tabbed group" })
    ,awful.key({ modkey, "Shift" }, "p", function (c) bling.module.tabbed.pop() end, { description = "remove the focused client from the tabbed group" })
    ,awful.key({ "Control" }, "tab", function (c) bling.module.tabbed.iter() end, { description = "iterate through the focused tabbed group" })
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

-- Set keys
root.keys(globalkeys)
-- }}}

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

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
          "Firewall",
          --" "
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "scratchpad"
        },
        type = {
          "dialog"
        }
      }, properties = { 
        floating = true,
        placement = awful.placement.centered + awful.placement.no_offscreen
      }},

    { 
      rule = {
        class = "jetbrains-webstorm",
        name = " "
      }, 
      properties = {
        floating = true,
        placement = awful.placement.centered
      }
    },

    -- Add titlebars to normal clients and dialogs
    --{ rule_any = {type = { "normal", "dialog" }
    --{ rule_any = {type = { "dialog" }
      --}, properties = { titlebars_enabled = true }
    --},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}


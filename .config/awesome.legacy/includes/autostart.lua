-- Autostart applications

awful.spawn.with_shell("volnoti -a 0.9")
awful.spawn.with_shell("~/.config/picom/start_picom.sh")
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
awful.spawn.with_shell("xfce4-power-manager")
awful.spawn.with_shell("pamac-tray")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("xautolock -time 40 -locker blurlock")
awful.spawn.with_shell("fix_cursor")
awful.spawn.with_shell("~/.config/awesome/post-start.sh")
awful.spawn.with_shell("wmname LG3D")

;==========================================================
;
;
;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
;
;
;   To learn more about how to configure Polybar
;   go to https://github.com/polybar/polybar
;
;   The README contains a lot of information
;
;==========================================================

[colors]
;background = ${xrdb:color0:#222}
background = #bb14191d
background-alt = #bb14191d
;background-alt = #13856e
foreground = #61c2ff
foreground-alt = #ffdfdf
primary = #61c2ff
secondary = #e60053
alert = #bd2c40
icon = #999
icon-positive = #61BD4F
icon-negative = #EF5350
active = #FFA20D
ws-active = #888

[bar/common]
enable-ipc = true
width = 100%
height = 21
fixed-center = true
background = ${colors.background}
foreground = ${colors.foreground}
line-size = 2
line-color = #f00
border-size = 0
padding-left = 0
padding-right = 0
padding-top = 0
padding-bottom = 0
module-margin-left = 1
module-margin-right = 1
#separator = "|"
separator = " "
;font-0 = InconsolataLGC-Nerd-Font-Mono:style=Regular:pixelsize=11;1
font-0 = Iosevka Nerd Font:style=Regular:pixelsize=11;1
font-1 = Weather Icons:size=11;0
wm-restack = i3
override-redirect = false
cursor-click = pointer
cursor-scroll = ns-resize
; If true, the bar will not shift its
; contents when the tray changes
tray-detached = false
; Tray icon max size
tray-maxsize = 20
; tray-transparent = false
tray-background = ${colors.background}


;==========================================================
; MAIN BAR
;==========================================================


[bar/main]
inherit = bar/common
bottom = false
monitor = ${env:MAIN_DISPLAY:HDMI-0}
modules-left = i3 xwindow
#modules-center = xwindow
modules-right = network wifinova wifilenovo wifidesktop pulseaudio smemory cpu cputemp weather info-trash battery datetime
tray-position = right
tray-scale = 1.0
tray-padding = 3
tray-background = ${colors.background}
tray-offset-x = 0%

[bar/left]
inherit = bar/common
monitor = ${env:TOP_DISPLAY}
bottom = true
modules-left = i3 xwindow
modules-right = network wifidesktop pulseaudio smemory cpu cputemp weather info-trash datetime

[bar/right]
inherit = bar/common
monitor = ${env:THIRD_DISPLAY}
bottom = true
modules-left = i3 xwindow
modules-right = network wifidesktop pulseaudio smemory cpu cputemp weather info-trash datetime

;==================================================
; STOCK MODULES
;==================================================

[module/xwindow]
type = internal/xwindow
label = %title:0:45:...%

[module/i3]
type = internal/i3
pin-workspaces = true
strip-wsnumbers = true
fuzzy-match = true
#index-sort = true
#format = <label-monitor> <label-state> %{FFFF}<label-mode>%{F}
#label-monitor = %name%
format = <label-state> %{FFFF}<label-mode>%{F}
label-empty =
label-empty-padding = 0

label-focused = %name%
label-focused-background = #3C5E5C
label-focused-foreground = ${colors.foreground-alt}
label-focused-padding = 1

label-unfocused = %name%
label-unfocused-padding = 1

label-urgent = %name%
label-urgent-foreground = ${colors.foreground-alt}
label-urgent-background = ${colors.alert}
label-urgent-padding = 1

label-occupied = %name%
label-occupied-padding = 1
label-occupied-foreground = #1870ad

# workspace that is active but not on the focused monitor
label-visible = %name%
label-visible-padding = 1
label-visible-underline=#EEEEEE

ws-icon-0 = 1
ws-icon-1 = 2
ws-icon-2 = 3
ws-icon-3 = 4
ws-icon-4 = 5
ws-icon-5 = 6
ws-icon-6 = 7
ws-icon-7 = 8
ws-icon-8 = 9
ws-icon-9 = 0

[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 80
border-bottom-size = 0
format = <label>
format-underline = ""
format-warn = <label-warn>
format-warn-underline = ""
label =  %temperature-c%
label-warn =  %temperature-c%

ramp-0 = 
ramp-1 = 
ramp-2 = 
ramp-foreground = ${colors.foreground-alt}

[module/powermenu]
type = custom/menu

expand-right = true

format-spacing = 1

label-open = 
label-open-foreground = ${colors.secondary}
label-close =  cancel
label-close-foreground = ${colors.secondary}
label-separator = |
label-separator-foreground = ${colors.foreground-alt}

menu-0-0 = reboot
menu-0-0-exec = menu-open-1
menu-0-1 = power off
menu-0-1-exec = menu-open-2

menu-1-0 = cancel
menu-1-0-exec = menu-open-0
menu-1-1 = reboot
menu-1-1-exec = sudo reboot

menu-2-0 = power off
menu-2-0-exec = sudo poweroff
menu-2-1 = cancel
menu-2-1-exec = menu-open-0

[settings]
screenchange-reload = true
;compositing-background = xor
;compositing-background = screen
;compositing-foreground = source
;compositing-border = over
;pseudo-transparency = false

[global/wm]
margin-top = 0
margin-bottom = 0

[section/base]
include-file = ~/.config/polybar/modules.ini


; vim:ft=dosini

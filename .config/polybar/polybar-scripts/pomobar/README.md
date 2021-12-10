# Pomobar

---

Pomodoro timer to polybar
![](img/pomodoro.gif)

## Requeriments 

* Polybar
* Icons: FontAwesome

## Getting Started

Only need copy pomobar.py in your system and call it in polybar

## Polybar config:
~~~.config/polybar/config

enable-ipc = true

[module/pomobar]
type=custom/ipc
hook-0 = cat ~/.pomobaroutput
initial=1
click-left = ~/src/scripts/pomobar.py --action=new &
click-middle= ~/src/scripts/pomobar.py --action=kill &
click-right = ~/src/scripts/pomobar.py --action=break &

~~~


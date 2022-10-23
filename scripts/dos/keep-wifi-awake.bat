:Loop
ping -n 2 4.2.2.2
ping -n 2 4.2.2.3
lollygag 30
ping -n 2 209.244.0.3
ping -n 2 209.244.0.4
lollygag 30
ping -n 2 208.67.222.222
ping -n 2 208.67.220.220
lollygag 30
ping -n 2 65.32.5.111
ping -n 2 65.32.5.112
lollygag 30
ping -n 2 206.13.29.12
ping -n 2 206.13.30.12
lollygag 30
ping -n 2 8.8.8.8
ping -n 2 8.8.4.4
lollygag 30
goto %Loop

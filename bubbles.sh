#!/bin/bash
cd ~/projects/mongrel2-musical-relay
make config
xterm -e make start &
cd ~/projects/bubble-warp
xterm -e perl http_bubble.pl &
xterm -e sclang bubble.sc &

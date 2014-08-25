#!/bin/bash
cd ../mongrel2-musical-relay
make config
rm run/mongrel2.pid
xterm -e make start &
cd ../bubble-warp
xterm -e perl http_bubble.pl &
xterm -e perl 404-bubble.pl  &
xterm -e sclang bubble.sc &
firefox http://127.0.0.1/demos/bubble.html &

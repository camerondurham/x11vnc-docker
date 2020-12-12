#!/bin/bash
Xvfb "$DISPLAY" -listen tcp -screen 0 2560x1440x24 &
/usr/bin/fluxbox -display "$DISPLAY" -screen 0 &
x11vnc -rfbport "$RFBPORT" -display "$DISPLAY" -N -forever &

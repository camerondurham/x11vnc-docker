#!/bin/bash

# replace running process with runit
# ensures runit starts at PID 1
exec /usr/sbin/runsvdir-start

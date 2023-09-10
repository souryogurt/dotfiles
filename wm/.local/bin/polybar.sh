#!/usr/bin/env bash

polybar-msg cmd quit
polybar bottom 2>&1 | tee -a /tmp/bottom.log & disown

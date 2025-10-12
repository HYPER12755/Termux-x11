#!/data/data/com.termux/files/usr/bin/bash

# Start PulseAudio
pulseaudio --start --exit-idle-time=-1 --disable-shm=1

# Set PulseAudio environment
export PULSE_SERVER=127.0.0.1

# Launch XFCE in Termux-X11
termux-x11 :0 -xstartup "dbus-launch --exit-with-session xfce4-session"

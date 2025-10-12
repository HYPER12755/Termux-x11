#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Updating and installing GUI components..."
pkg update -y && pkg upgrade -y
pkg install -y x11-repo tur-repo
pkg reinstall -y termux-x11-nightly pulseaudio xfce4 dbus

echo "[*] Creating GUI launch script (start-x11.sh)..."
cat > start-x11.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Start PulseAudio
pulseaudio --start --exit-idle-time=-1 --disable-shm=1

# Set PulseAudio environment
export PULSE_SERVER=127.0.0.1

# Launch XFCE in Termux-X11
termux-x11 :0 -xstartup "dbus-launch --exit-with-session xfce4-session"
EOF

chmod +x start-x11.sh
echo "[✓] Installation complete. GUI launcher saved as ./start-x11.sh"

# OPTIONAL: Automatically start GUI after install
read -p "Do you want to start the GUI now? (y/n): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    ./start-x11.sh
else
    echo "You can launch it later using: ./start-x11.sh"
fi

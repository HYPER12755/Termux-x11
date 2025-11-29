#!/usr/bin/env bash
# setup-x11.sh
# Cross-environment installer for Termux-X11 repo
# Works on: Termux (pkg), proot/NetHunter/Debian/Ubuntu (apt)
# Installs XFCE/X11 or VNC fallback and creates start scripts.

set -e
ME=$(basename "$0")

info(){ echo -e "\e[1;34m[INFO]\e[0m $*\n"; }
warn(){ echo -e "\e[1;33m[WARN]\e[0m $*\n"; }
err(){ echo -e "\e[1;31m[ERROR]\e[0m $*\n"; exit 1; }

detect_env(){
  # Detect environment: termux vs apt-based linux (proot)
  if [ -n "$PREFIX" ] && [ -x "$PREFIX/bin/pkg" ]; then
    # Running under Termux (most likely)
    echo "termux"
    return
  fi

  if [ -x "/usr/bin/apt" ] || [ -x "/usr/bin/apt-get" ]; then
    echo "deb"
    return
  fi

  # fallback
  echo "unknown"
}

ENVTYPE=$(detect_env)
info "Detected environment: $ENVTYPE"

if [ "$ENVTYPE" = "termux" ]; then
  info "Installing packages via pkg (Termux) ..."
  # enable x11-repo if not enabled
  if ! pkg list-installed x11-repo >/dev/null 2>&1; then
    pkg install -y x11-repo || warn "x11-repo install failed or already present"
  fi

  pkg update -y
  pkg upgrade -y
  pkg install -y x11-repo xfce4 pulseaudio dbus-x11 x11-utils xterm wget git proot tar \
                 tigervnc python nano || true

  info "Note: Termux environment expects you to use Termux:X11 or XServer XSDL app on Android."
  info "If you have Termux:X11 (app) installed, start it before launching GUI from this rootfs."
elif [ "$ENVTYPE" = "deb" ]; then
  info "Using apt (Debian/Ubuntu/Kali/NetHunter). Installing packages..."
  apt update -y || true
  apt install -y xfce4 xfce4-goodies dbus-x11 x11-utils xterm wget git tigervnc-standalone-server \
                  pulseaudio pulseaudio-utils pulseaudio-module-x11 || warn "Some packages failed to install; continue anyway"
  info "If apt asks to fix broken packages run: apt --fix-broken install -y"
else
  warn "Unknown environment. I'll still create start scripts, but you must install X11 & XFCE manually."
fi

# create start scripts (delegates to start-x11.sh)
cat > start-x11.sh <<'EOF'
#!/usr/bin/env bash
# start-x11.sh - unified launcher
# usage: ./start-x11.sh [termux|xsdl|vnc]
MODE="$1"

# helper: detect if Termux X server app is running (simple check)
is_termux() {
  [ -n "$PREFIX" ] && [ -x "$PREFIX/bin/pkg" ]
}

# default mode selection
if [ -z "$MODE" ]; then
  if is_termux ; then
    MODE="termux"
  else
    # prefer xsdl if DISPLAY is present, else vnc
    if [ -n "$DISPLAY" ]; then MODE="xsdl"; else MODE="vnc"; fi
  fi
fi

echo "[*] Launch mode: $MODE"

case "$MODE" in
  termux)
    # Termux + Termux:X11 or XServer XSDL client
    # In Termux:X11, display is usually :0 or 127.0.0.1:0. Test a few options.
    export DISPLAY=${DISPLAY:-127.0.0.1:0}
    echo "[*] Using DISPLAY=$DISPLAY"
    # start pulseaudio if available (non-root in Termux)
    if command -v pulseaudio >/dev/null 2>&1 ; then
      pulseaudio --start --exit-idle-time=-1 2>/dev/null || echo "pulseaudio start failed (ok)"
    fi
    # Ensure dbus
    if command -v dbus-launch >/dev/null 2>&1 ; then
      dbus-launch --exit-with-session startxfce4 >/dev/null 2>&1 &
    else
      startxfce4 >/dev/null 2>&1 &
    fi
    echo "[*] XFCE started. Switch to Termux:X11 / XServer XSDL app to view."
    ;;
  xsdl)
    # XServer XSDL uses DISPLAY :0 and port mapping - user must start the app first
    export DISPLAY=${DISPLAY:-:0}
    echo "[*] Using DISPLAY=$DISPLAY (XServer XSDL)"
    if command -v pulseaudio >/dev/null 2>&1 ; then
      pulseaudio --start --exit-idle-time=-1 2>/dev/null || true
    fi
    if command -v dbus-launch >/dev/null 2>&1 ; then
      dbus-launch --exit-with-session startxfce4 >/dev/null 2>&1 &
    else
      startxfce4 >/dev/null 2>&1 &
    fi
    echo "[*] XFCE started. Open your XSDL client app now."
    ;;
  vnc)
    # VNC fallback: starts TigerVNC server at :1 (5901)
    echo "[*] Starting VNC server on display :1 (port 5901)..."
    # create a simple xstartup if not present
    mkdir -p ~/.vnc
    if [ ! -f ~/.vnc/xstartup ]; then
      cat > ~/.vnc/xstartup <<'XSU'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
XSU
      chmod +x ~/.vnc/xstartup
    fi
    # set default geometry if not set
    GEOM=${GEOMETRY:-1280x720}
    vncserver :1 -geometry "$GEOM" -depth 24
    echo "[*] VNC server running. Connect with a VNC viewer to localhost:5901"
    ;;
  *)
    echo "Usage: $0 [termux|xsdl|vnc]"
    exit 1
    ;;
esac

EOF

chmod +x start-x11.sh

# small README snippet
cat > README_X11.md <<'MD'
# Termux-X11 cross-env (Termux + proot + apt) — quick start

## Setup
Run:

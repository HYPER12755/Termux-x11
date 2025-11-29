🚀 Termux-X11: Easy Desktop for Termux + NetHunter + All Distros

Run a full Linux desktop (XFCE) on any Android phone — no root, fast, stable, universal.

This setup works on:

Termux

Kali NetHunter (root & non-root)

proot-distro (Debian / Ubuntu / Kali / Arch / etc.)


Just clone → run → launch desktop.
No manual configs. No broken dependencies. No stress. 😎


---

🔥 Features

Auto-detects environment (Termux / NetHunter / proot)

Installs all required X11 packages

Supports Termux:X11, XServer XSDL, VNC

One universal launcher → ./start-x11.sh

Fixed paths, fixed display issues, fixed perms

Works with all Kali & Linux tools



---

⚡ Quick Install (1 command)

git clone https://github.com/HYPER12755/Termux-X11.git && cd Termux-X11 && bash setup-x11.sh

Done.
Now choose how you want to start the desktop 👇


---

🎨 Start the Desktop

1️⃣ Termux:X11 (BEST Quality)

Install Termux:X11 app → open it → then run:

./start-x11.sh termux

✔ Fast
✔ Smooth
✔ Real fullscreen
✔ Official X11 support


---

2️⃣ XServer XSDL (Second Option)

Install XServer XSDL, open it, then run:

./start-x11.sh xsdl


---

3️⃣ VNC Mode (Works Everywhere)

./start-x11.sh vnc

Connect using any VNC viewer:

Address: localhost
Port: 5901

Use this mode inside:

Kali NetHunter

proot-distro (Debian/Kali/Ubuntu)

WSL-chroot-like setups



---

🧰 Using With Distros (Debian/Kali/Ubuntu)

Enter the distro:

proot-distro login debian
# or
proot-distro login kali

Inside the distro:

cd ~/Termux-X11
bash setup-x11.sh
./start-x11.sh vnc


---

🛠 Commands You Should Know

Restart VNC

vncserver -kill :1
vncserver :1

Fix broken packages

apt --fix-broken install

Reinstall desktop

bash setup-x11.sh

Change resolution

GEOMETRY=1366x768 ./start-x11.sh vnc

Launch XFCE manually

startxfce4


---

🎯 Best Environment for Full Hacking Tools

If you want all Kali Linux tools, use this order:

✔ Termux
⬇
✔ Install NetHunter rootless
⬇
✔ Install your Termux-X11
⬇
✔ Use XFCE through VNC
⬇
✔ Install tools:

sudo apt install kali-tools-top10 kali-linux-default

Yes — every Kali tool works inside the desktop.


---

⚠️ Notes

Termux prohibits pkg inside proot → script handles this automatically.

Termux:X11 returns “Operation not permitted” if run as root → use user mode.

PulseAudio may give warnings → desktop works fine.



---

🙌 Credits

Clean, simple, universal desktop setup for everyone who wants a real Linux feel on Android.


---

🦾 Want More?

I can add:

🔥 KDE Plasma
🔥 GNOME (Lite mod)
🔥 LXDE / LXQt
🔥 MATE
🔥 Wayland mode
🔥 Auto-installer for NetHunter rootless
🔥 One-click uninstall script
🔥 GUI settings manager

Just tell me what you want and I’ll build it. 😎✨

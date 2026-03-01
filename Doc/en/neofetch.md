# neofetch

Displays system information alongside ASCII art.

---

## Usage

```bash
neofetch
```

Run when opening a new terminal or entering a new environment to quickly check
OS, kernel, CPU, memory, and other system details.

---

## Displayed Information

| Field | Content |
|-------|---------|
| OS | Distribution name and version |
| Host | Hostname and machine model |
| Kernel | Kernel version |
| Uptime | System uptime |
| Packages | Number of installed packages |
| Shell | Current shell and version |
| Resolution | Screen resolution (if desktop environment is available) |
| DE / WM | Desktop environment / window manager |
| Terminal | Terminal emulator in use |
| CPU | Processor name and core count |
| GPU | Graphics card (if detectable) |
| Memory | Used / total memory |

---

## Common Options

```bash
neofetch --off            # Show info only, no ASCII art
neofetch --ascii_distro ubuntu  # Use a different distro's ASCII art
neofetch --config none    # Ignore config file
```

---

## Configuration File

Customize displayed fields, colors, and ASCII art in `~/.config/neofetch/config.conf`.

```bash
# Generate config file (first time)
neofetch --config ~/.config/neofetch/config.conf
```

Key settings:
- Comment out `info` lines to hide specific fields
- Change `image_backend` to use images instead of ASCII art (requires kitty / iTerm2 / WezTerm)
- Customize `colors` for the color scheme

---

## WSL Note

On WSL2, GPU info and screen resolution may not be detected correctly.
Using `neofetch --off` gives stable output for the info section only.

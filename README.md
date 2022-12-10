# Name
backlightd - backlight service who save the current brightness value on shutdown nor reboot.

# Installation
``` bash
./install
```

# Uninstall
``` bash
./remove
```

# Notes
disable systemd-backlight@backlight:acpi_video0 service or another backlight service before apply this module.

only linux with systemd will works with this module.
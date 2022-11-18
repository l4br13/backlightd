# Name
backlightd - backlight service who save the current brightness value on shutdown nor reboot.

# Installation
Just execute
``` bash
	./install
```
you see there are install and uninstall file there.

# Notes
disable systemd-backlight@backlight:acpi_video0 service or another backlight service before apply this module.

only linux with systemd will works with this module.
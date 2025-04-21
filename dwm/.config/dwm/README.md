# dwm - dynamic window manager

## Patches

### Applied patches

- [alwayscenter](https://dwm.suckless.org/patches/alwayscenter/)
- [autostarttags](https://dwm.suckless.org/patches/autostarttags/)
- [notitle](https://dwm.suckless.org/patches/notitle/)
- [pertag](https://dwm.suckless.org/patches/pertag/)
- [preserveonrestart](https://dwm.suckless.org/patches/preserveonrestart/)
- [rainbowtags](https://dwm.suckless.org/patches/rainbowtags/)
- [removeborder](https://dwm.suckless.org/patches/removeborder/)
- [status2d](https://dwm.suckless.org/patches/status2d/)
- [systray](https://dwm.suckless.org/patches/systray/)
- [underlinetags](https://dwm.suckless.org/patches/underlinetags/)

### How to apply patches

```bash
patch -p1 < <patch_path>
```

### How to Unpatch

```bash
patch -R < <patch_path>
```

dwm is an extremely fast, small, and dynamic window manager for X.

## Requirements

In order to build dwm you need the Xlib header files.

## Installation

Edit `config.mk` to match your local setup (dwm is installed into
the `/usr/local` namespace by default).

Afterwards enter the following command to build and install dwm (if
necessary as root):

```bash
make clean install
```

## Running dwm

Add the following line to your .xinitrc to start dwm using startx:

```bash
exec dwm
```

In order to connect dwm to a specific display, make sure that
the `DISPLAY` environment variable is set correctly, e.g.:

```bash
DISPLAY=foo.bar:1 exec dwm
```

(This will start dwm on display :1 of the host foo.bar.)

In order to display status info in the bar, you can do something
like this in your .xinitrc:

```bash
while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
do
  sleep 1
done &
exec dwm
```

## Configuration

The configuration of dwm is done by creating a custom config.h
and (re)compiling the source code.

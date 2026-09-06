```
otd-daemon
```

```
sudo modprobe uinput
sudo udevadm control --reload-rules
sudo udevadm trigger
systemctl --user restart opentabletdriver
```

```
sudo rmmod wacom hid_uclogic 2>/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo mkinitcpio -P
```

```
reboot
```
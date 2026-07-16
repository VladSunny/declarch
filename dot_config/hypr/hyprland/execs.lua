-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function () 
    hl.exec_cmd("awww-daemon --format xrgb")
    hl.exec_cmd("awww img ~/Pictures/Wallpapers/Lain3.jpeg --transition-type random --transition-step 255 --transition-fps 90 --transition-bezier .43,.43,.12,.88")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark")
end)

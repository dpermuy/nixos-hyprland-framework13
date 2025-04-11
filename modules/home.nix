# modules/home.nix
{ config, lib, pkgs, username, hyprland, hyprlock, hypridle, hyprpaper, ... }:

{
  imports = [
    ./theme.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Packages specific to the user
  home.packages = with pkgs; [
    # Additional tools that might be useful
    jetbrains-mono  # A good programming font
    neofetch
    btop
    ranger

    # Multimedia
    mpv
    imv  # Image viewer

    # Theme tools
    papirus-icon-theme
    dracula-theme
  ];

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;

    extraConfig = ''
      # Monitor configuration
      monitor=,preferred,auto,1

      # Set variables
      $terminal = kitty
      $menu = wofi --show drun
      $browser = firefox
      $fileManager = thunar
      $mainMod = SUPER

      # Autostart applications
      exec-once = waybar
      exec-once = hyprpaper
      exec-once = hypridle
      exec-once = swaync

      # Some default env vars
      env = XCURSOR_SIZE,24
      env = QT_QPA_PLATFORMTHEME,qt5ct

      # For screen sharing
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # Theme
      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgb(bd93f9) rgb(ff79c6) 45deg
        col.inactive_border = rgb(44475a)
        layout = dwindle
      }

      decoration {
        rounding = 10
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)

        blur {
          enabled = true
          size = 3
          passes = 1
          new_optimizations = true
        }
      }

      animations {
        enabled = true

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      dwindle {
        pseudotile = true
        preserve_split = true
      }

      # Mouse behavior
      input {
        follow_mouse = 1
        sensitivity = 0.5
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
      }

      # Window rules
      windowrule = float, ^(pavucontrol)$
      windowrule = float, ^(blueman-manager)$

      # Key bindings
      bind = $mainMod, Return, exec, $terminal
      bind = $mainMod, Q, killactive
      bind = $mainMod, M, exit
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating
      bind = $mainMod, D, exec, $menu
      bind = $mainMod, P, pseudo
      bind = $mainMod, F, fullscreen
      bind = $mainMod, B, exec, $browser

      # Move focus
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move windows to workspaces
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };

  # Kitty terminal configuration with Dracula theme
  programs.kitty = {
    enable = true;
    theme = "Dracula";
    settings = {
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 12;
      enable_audio_bell = false;
      window_padding_width = 10;
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: #282a36;
        color: #f8f8f2;
      }

      #workspaces button {
        padding: 0 10px;
        background: #44475a;
        color: #f8f8f2;
        border-bottom: 3px solid transparent;
      }

      #workspaces button.active {
        background: #bd93f9;
        border-bottom: 3px solid #ff79c6;
      }

      #mode, #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #idle_inhibitor {
        padding: 0 10px;
        margin: 0 5px;
        background: #44475a;
        color: #f8f8f2;
      }

      #battery.charging {
        background: #50fa7b;
        color: #282a36;
      }

      #battery.critical:not(.charging) {
        background: #ff5555;
        color: #f8f8f2;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background: #f8f8f2;
          color: #ff5555;
        }
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["hyprland/workspaces" "hyprland/mode"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "cpu" "memory" "battery" "tray"];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };

        clock = {
          format = "{:%a, %b %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "CPU {usage}%";
          tooltip = false;
        };

        memory = {
          format = "MEM {}%";
        };

        battery = {
          bat = "BAT0";
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTED";
          on-click = "pavucontrol";
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };
      };
    };
  };

  # Wofi configuration
  programs.wofi = {
    enable = true;
    settings = {
      width = "50%";
      height = "40%";
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
    };
    style = ''
      * {
        font-family: JetBrains Mono;
        font-size: 14px;
      }

      window {
        margin: 0px;
        border: 2px solid #bd93f9;
        background-color: #282a36;
        border-radius: 15px;
      }

      #input {
        margin: 5px;
        border: 2px solid #6272a4;
        background-color: #44475a;
        color: #f8f8f2;
        border-radius: 10px;
      }

      #inner-box {
        margin: 5px;
        background-color: #282a36;
        color: #f8f8f2;
        border-radius: 10px;
      }

      #outer-box {
        margin: 5px;
        padding: 10px;
        background-color: #282a36;
        border-radius: 10px;
      }

      #scroll {
        margin: 5px;
        border: 2px solid #6272a4;
        background-color: #44475a;
        border-radius: 10px;
      }

      #text {
        margin: 5px;
        color: #f8f8f2;
      }

      #entry:selected {
        background-color: #44475a;
        border-radius: 10px;
      }

      #text:selected {
        color: #ff79c6;
      }
    '';
  };

  # SwayNC configuration
  xdg.configFile."swaync/config.json".text = ''
    {
      "layer": "top",
      "output": "",
      "position": "top-right",
      "control-center-margin-top": 10,
      "control-center-margin-bottom": 10,
      "control-center-margin-right": 10,
      "control-center-margin-left": 10,
      "notification-icon-size": 64,
      "notification-body-image-height": 100,
      "notification-body-image-width": 200,
      "timeout": 10,
      "timeout-low": 5,
      "timeout-critical": 0,
      "fit-to-screen": true,
      "control-center-width": 500,
      "control-center-height": 600,
      "notification-window-width": 500
    }
  '';

  xdg.configFile."swaync/style.css".text = ''
    .notification-row {
      outline: none;
      margin: 10px;
      padding: 10px;
      background-color: #282a36;
      border-radius: 10px;
      border: 2px solid #44475a;
    }

    .notification-row:hover {
      background-color: #44475a;
    }

    .notification {
      background-color: transparent;
      padding: 10px;
      border-radius: 10px;
      margin: 5px;
      border: none;
    }

    .notification-content {
      background: transparent;
      color: #f8f8f2;
    }

    .notification-default-action,
    .notification-action {
      padding: 5px;
      margin: 5px;
      border-radius: 5px;
      background-color: #44475a;
      border: none;
      color: #f8f8f2;
    }

    .notification-default-action:hover,
    .notification-action:hover {
      background-color: #6272a4;
    }

    .close-button {
      background-color: #ff5555;
      color: #f8f8f2;
      text-shadow: none;
      padding: 2px;
      border-radius: 5px;
      margin: 5px;
    }

    .close-button:hover {
      background-color: #ff79c6;
    }
  '';

  # Hyprpaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/wallpaper.jpg
    wallpaper = ,~/.config/hypr/wallpaper.jpg
    splash = false
  '';

  # Hyprlock configuration
  xdg.configFile."hypr/hyprlock.conf".text = ''
    background {
        monitor =
        path = ~/.config/hypr/wallpaper.jpg
        color = rgb(282a36)
    }

    input-field {
        monitor =
        size = 200, 50
        outline_thickness = 2
        dots_size = 0.2
        dots_spacing = 0.2
        dots_center = true
        outer_color = rgb(bd93f9)
        inner_color = rgb(44475a)
        font_color = rgb(f8f8f2)
        fade_on_empty = true
        placeholder_text = <i>Password...</i>
        hide_input = false
        position = 0, -150
        halign = center
        valign = center
    }

    label {
        monitor =
        text = Enter password to unlock
        color = rgb(f8f8f2)
        font_size = 20
        font_family = JetBrains Mono
        position = 0, -250
        halign = center
        valign = center
    }
  '';

  # Hypridle configuration
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = hyprlock
        unlock_cmd = killall hyprlock
        before_sleep_cmd = hyprlock
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 300
        on-timeout = hyprlock
    }

    listener {
        timeout = 600
        on-timeout = systemctl suspend
    }

    listener {
        timeout = 1800
        on-timeout = systemctl hibernate
    }
  '';

  # Git configuration
  programs.git = {
    enable = true;
    userName = "dylan";  # Change to your name
    userEmail = "dylan@permuy.me";  # Change to your email
  };

  # Firefox configuration
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
      settings = {
        "browser.startup.homepage" = "https://nixos.org";
        "browser.search.region" = "US";
        "browser.search.isUS" = true;
        "browser.ctrlTab.recentlyUsedOrder" = false;
      };
      userChrome = ''
        /* Add dracula theme tweaks here */
        :root {
          --toolbar-bgcolor: #282a36 !important;
          --tab-selected-bgcolor: #44475a !important;
          --urlbar-box-bgcolor: #44475a !important;
          --urlbar-box-hover-bgcolor: #6272a4 !important;
          --toolbar-color: #f8f8f2 !important;
        }
      '';
    };
  };
}

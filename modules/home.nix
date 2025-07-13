# Complete enhanced modules/home.nix for Framework 13 AMD
# Includes performance optimizations, Hyprspace, auto-start btop wallpaper, and gesture support
{ config, pkgs, lib, hyprland, ... }:

{
  # ===== HOME MANAGER BASICS =====
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # ===== HYPRLAND CONFIGURATION =====
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    
    extraConfig = ''
      # ===== MONITOR CONFIGURATION =====
      # Framework 13 (3:2 aspect ratio) with 1.6x scaling for optimal readability
      monitor=eDP-1,preferred,auto,1.6

      # ===== XWAYLAND SETTINGS =====
      xwayland {
          force_zero_scaling = true
      }

      # ===== ENVIRONMENT VARIABLES =====
      env = XCURSOR_THEME,Nordzy-cursors
      env = XCURSOR_SIZE,40
      env = WLR_NO_HARDWARE_CURSORS,1
      env = GDK_SCALE,1.6
      env = GDK_DPI_SCALE,0.625
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_SCALE_FACTOR,1.6
      env = MOZ_ENABLE_WAYLAND,1

      # ===== INPUT CONFIGURATION =====
      input {
          kb_layout = us
          follow_mouse = 1
          sensitivity = 0
          accel_profile = flat

          touchpad {
              natural_scroll = true
              disable_while_typing = true
              clickfinger_behavior = true
              tap-to-click = false
              scroll_factor = 0.3
              drag_lock = false
              tap-and-drag = false
          }
      }

        # ===== GENERAL APPEARANCE =====
        general {
            gaps_in = 3      # Reduced from 8 to 3
            gaps_out = 6     # Reduced from 16 to 6
            border_size = 2  # Reduced from 3 to 2 (optional)
            col.active_border = rgba(bd93f9ff) rgba(ff79c6ff) 45deg
            col.inactive_border = rgba(44475aff)
            layout = dwindle
    
            # Performance optimizations - updated for newer Hyprland
            resize_on_border = true
            extend_border_grab_area = 5
        }

      # ===== DECORATION (OPTIMIZED FOR PERFORMANCE) =====
      decoration {
          rounding = 10
          
          blur {
              enabled = true
              size = 3
              passes = 1
              new_optimizations = true
              xray = false
              ignore_opacity = false
              noise = 0.0117
              contrast = 0.8916
              brightness = 0.8172
          }
          
          # Shadow settings - updated syntax
          shadow {
              enabled = false
          }
      }

      # ===== OPTIMIZED ANIMATIONS (70% FASTER) =====
      animations {
          enabled = true
          
          # Fast, snappy bezier curves
          bezier = overshot, 0.13, 0.99, 0.29, 1.1
          bezier = smoothOut, 0.36, 0, 0.66, -0.56
          bezier = smoothIn, 0.25, 1, 0.5, 1
          bezier = realsmooth, 0.28, 0.29, 0.69, 1.08
          
          # Much faster animations for snappy feel
          animation = windows, 1, 3, overshot, slide
          animation = windowsOut, 1, 2, smoothOut, slide
          animation = windowsMove, 1, 2, smoothIn, slide
          animation = border, 1, 5, default
          animation = borderangle, 1, 5, default
          animation = fade, 1, 3, smoothIn
          animation = fadeDim, 1, 3, smoothIn
          animation = workspaces, 1, 3, realsmooth, slide
          animation = specialWorkspace, 1, 3, realsmooth, slidevert
          animation = layers, 1, 2, overshot, slide
      }

      # ===== LAYOUT SETTINGS =====
      dwindle {
          pseudotile = true
          preserve_split = true
          force_split = 0
          split_width_multiplier = 1.0
          use_active_for_splits = true
      }

      # ===== PERFORMANCE AND BEHAVIOR =====
      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          mouse_move_enables_dpms = true
          key_press_enables_dpms = true
          animate_manual_resizes = true
          animate_mouse_windowdragging = true
          enable_swallow = true
          swallow_regex = ^(kitty)$
          focus_on_activate = false
          force_default_wallpaper = 0
          vfr = true
      }

      # ===== HYPRSPACE PLUGIN CONFIGURATION =====
      plugin:hyprspace {
          # Overview settings optimized for Framework 13
          overview_gappo = 60
          overview_gappi = 24
          workspaces_per_row = 3
          overview_scale = 0.3
          
          # Fast animations
          anim_duration = 0.2
          
          # Behavior
          overview_center_1 = true
          overview_only_search_visible = true
          
          # Dracula theme colors
          overview_bg_color = rgba(40, 42, 54, 0.85)
          overview_border_color = rgba(189, 147, 249, 1)
          overview_border_inactive_color = rgba(68, 71, 90, 1)
      }

      # ===== AUTOSTART APPLICATIONS =====
      exec-once = hyprpaper
      exec-once = swaync
      exec-once = nm-applet --indicator
      exec-once = blueman-applet
      exec-once = cliphist daemon
      exec-once = libinput-gestures
      
      # Set cursor theme and size
      exec-once = hyprctl setcursor Nordzy-cursors 40
      
      # AUTO-START BTOP WALLPAPER (with longer delay for debugging)
      exec-once = sleep 8 && btop-wallpaper-autostart

      # ===== KEY BINDINGS =====
      # Basic window management
      bind = SUPER, Return, exec, kitty
      bind = SUPER, Q, killactive
      bind = SUPER, M, exit
      bind = SUPER, E, exec, thunar
      bind = SUPER, V, togglefloating
      bind = SUPER, F, fullscreen
      bind = SUPER, B, exec, firefox

      # Application launcher (optimized Wofi)
      bind = SUPER, D, exec, env GDK_SCALE=1.6 wofi --show drun
      bindr = SUPER, Super_L, exec, env GDK_SCALE=1.6 wofi --show drun

      # Hyprspace workspace overview - updated dispatcher syntax
      bind = SUPER, Space, exec, hyprctl dispatch hyprspace:toggleoverview
      bind = SUPER ALT, Space, exec, hyprctl dispatch hyprspace:toggleoverview

      # Btop wallpaper management
      bind = SUPER SHIFT, B, exec, btop-wallpaper toggle
      bind = SUPER CTRL, B, exec, btop-wallpaper start corner

      # Window focus (vim-style)
      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d

      # Move windows (vim-style)
      bind = SUPER SHIFT, H, movewindow, l
      bind = SUPER SHIFT, L, movewindow, r
      bind = SUPER SHIFT, K, movewindow, u
      bind = SUPER SHIFT, J, movewindow, d

      # Resize windows (vim-style + ALT)
      bind = SUPER ALT, H, resizeactive, -25 0
      bind = SUPER ALT, L, resizeactive, 25 0
      bind = SUPER ALT, K, resizeactive, 0 -25
      bind = SUPER ALT, J, resizeactive, 0 25

      # Workspace switching
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      # Move windows to workspaces
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      # Mouse bindings
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Audio control
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

      # Framework 13 F-key audio controls
      bind = , F1, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , F2, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , F3, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

      # Brightness control
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
      bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
      bind = , F7, exec, brightnessctl set 5%-
      bind = , F8, exec, brightnessctl set 5%+

      # Power and session management
      bind = , XF86PowerOff, exec, wlogout
      bind = SUPER CTRL, L, exec, swaylock
      bind = SUPER SHIFT, Q, exec, wlogout

      # Screenshots
      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = SHIFT, Print, exec, grim - | wl-copy
      bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png

      # Clipboard history
      bind = SUPER, C, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

      # ===== WINDOW RULES =====
      # Floating windows - all using windowrulev2 syntax
      windowrulev2 = float,class:pavucontrol
      windowrulev2 = float,class:blueman-manager
      windowrulev2 = float,class:nm-connection-editor
      windowrulev2 = float,class:file-roller
      windowrulev2 = float,title:Picture-in-Picture
      windowrulev2 = float,class:org.gnome.Calculator
      windowrulev2 = float,class:org.gnome.Characters
      windowrulev2 = float,class:org.gnome.clocks

      # Window sizing - all using windowrulev2 syntax
      windowrulev2 = size 800 600,class:pavucontrol
      windowrulev2 = center,class:pavucontrol
      windowrulev2 = size 60% 60%,title:Picture-in-Picture
      windowrulev2 = move 39% 39%,title:Picture-in-Picture

      # Btop wallpaper specific rules - enhanced for wallpaper-like behavior
      windowrulev2 = float,class:btop-wallpaper
      windowrulev2 = pin,class:btop-wallpaper
      windowrulev2 = nofocus,class:btop-wallpaper
      windowrulev2 = noborder,class:btop-wallpaper
      windowrulev2 = noshadow,class:btop-wallpaper
      windowrulev2 = opacity 0.8,class:btop-wallpaper
      windowrulev2 = noanim,class:btop-wallpaper
      windowrulev2 = noinitialfocus,class:btop-wallpaper
      windowrulev2 = minsize 1 1,class:btop-wallpaper
      windowrulev2 = maxsize 99999 99999,class:btop-wallpaper

      # Power management window rules
      windowrulev2 = float,class:floating-terminal
      windowrulev2 = size 800 600,class:floating-terminal
      windowrulev2 = center,class:floating-terminal

      # Workspace assignments
      windowrulev2 = workspace 2,class:firefox
      windowrulev2 = workspace 3,class:code
      windowrulev2 = workspace 4,class:discord

      # Performance rules
      windowrulev2 = immediate,class:steam_app_.*
      windowrulev2 = immediate,class:lutris
      windowrulev2 = immediate,class:bottles

      # Transparency
      windowrulev2 = opacity 0.95,class:kitty
      windowrulev2 = opacity 0.95,class:thunar
      windowrulev2 = opacity 0.9,class:wofi
    '';
  };

  # ===== GESTURE CONFIGURATION =====
  home.file.".config/libinput-gestures.conf".text = ''
    # Gesture configuration for Framework 13 touchpad
    
    # Three finger swipe up/down - Hyprspace toggle
    gesture: swipe up 3 hyprctl dispatch hyprspace:toggleoverview
    gesture: swipe down 3 hyprctl dispatch hyprspace:toggleoverview
    
    # Four finger workspace switching
    gesture: swipe left 4 hyprctl dispatch workspace +1
    gesture: swipe right 4 hyprctl dispatch workspace -1
    
    # Three finger browser navigation
    gesture: swipe left 3 xdotool key alt+Right
    gesture: swipe right 3 xdotool key alt+Left
    
    # Four finger pinch for overview (alternative)
    gesture: pinch in 4 hyprctl dispatch hyprspace:toggleoverview
    gesture: pinch out 4 hyprctl dispatch hyprspace:toggleoverview
    
    # Configuration settings
    swipe_threshold: 0.6
    timeout: 300
    
    # Device-specific tuning for Framework 13
    device: PIXA3854:00 093A:0274 Touchpad
  '';

  # ===== TERMINAL CONFIGURATION =====
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    settings = {
      # Visual settings
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 15;
      window_padding_width = 12;
      
      # Performance optimizations
      repaint_delay = 8;
      input_delay = 2;
      sync_to_monitor = true;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      
      # Animation settings
      window_resize_step_cells = 2;
      window_resize_step_lines = 2;
      
      # Additional optimizations
      scrollback_lines = 2000;
      wheel_scroll_multiplier = 3.0;
      touch_scroll_multiplier = 1.0;
    };
  };

  # ===== VS CODE CONFIGURATION =====
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        bbenoist.nix
        ms-vscode.hexeditor
        ms-python.python
        ms-vscode.cpptools
        bradlc.vscode-tailwindcss
      ];
      userSettings = {
        # Font and display
        "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', monospace";
        "editor.fontSize" = 16;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.4;
        
        # Theme and UI
        "workbench.colorTheme" = "Dracula";
        "window.zoomLevel" = 0.5;
        "editor.minimap.enabled" = false;
        "workbench.activityBar.location" = "top";
        
        # Performance optimizations
        "editor.accessibilitySupport" = "off";
        "extensions.autoUpdate" = false;
        "search.followSymlinks" = false;
        "search.useRipgrep" = true;
        "editor.semanticHighlighting.enabled" = false;
        
        # File watching exclusions
        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/node_modules/*/**" = true;
          "**/.hg/store/**" = true;
          "**/target/**" = true;
          "**/.next/**" = true;
        };
        
        # Editor behavior
        "editor.renderWhitespace" = "boundary";
        "files.autoSave" = "afterDelay";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "workbench.list.smoothScrolling" = true;
        "editor.smoothScrolling" = true;
        
        # Privacy
        "telemetry.telemetryLevel" = "off";
        "workbench.enableExperiments" = false;
      };
    };
  };

  # ===== FIREFOX CONFIGURATION =====
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
      settings = {
        # Performance settings
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;
        
        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "dom.security.https_only_mode" = true;
        
        # Scaling optimized for Framework 13
        "layout.css.devPixelsPerPx" = "1.0";
        "browser.uidensity" = 0;
        
        # Performance optimizations
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 204800;
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "browser.tabs.animate" = false;
        "browser.fullscreen.animate" = false;
        "browser.panorama.animate_zoom" = false;
        
        # Scrolling improvements
        "general.smoothScroll" = true;
        "general.smoothScroll.lines.durationMaxMS" = 125;
        "general.smoothScroll.lines.durationMinMS" = 125;
        "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
        "general.smoothScroll.mouseWheel.durationMinMS" = 100;
        
        # Additional optimizations
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.loadInBackground" = true;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = true;
        "layout.css.dpi" = 0;
        "browser.zoom.full" = true;
        "browser.display.os-zoom-behavior" = 1;
        "browser.zoom.defaultZoom" = "1.0";

        # Increase UI font size
        "ui.textScaleFactor" =150;  # Increase from 100 to 130 (or try 140-150)
      
        # Force Firefox to use system font settings
        "ui.systemUsesDarkTheme" = 1;
        "widget.use-xdg-desktop-portal" = true;
        "widget.use-xdg-desktop-portal.settings" = 1;
      
        # Ensure browser chrome uses larger fonts
        "layout.css.text-size-adjust.enabled" = true;
        "browser.display.use_system_colors" = true;
      };
    };
  };

  # ===== WOFI CONFIGURATION (PERFORMANCE OPTIMIZED) =====
  home.file.".config/wofi/config".text = ''
    # Performance-optimized Wofi for Framework 13
    width=400
    height=500
    show=drun
    mode=drun
    allow_images=true
    image_size=40
    columns=1
    orientation=vertical
    location=center
    halign=fill
    valign=center
    font=JetBrains Mono 14
    prompt=Apps
    filter_rate=50
    allow_markup=false
    no_actions=true
    show_all=false
    print_command=true
    layer=overlay
    insensitive=true
    matching=contains
    cache_file=/home/dylan/.cache/wofi-drun
    gtk_dark=true
    dpi_aware=false
    normal_window=false
    term=kitty
    exec_search=false
    key_expand=Tab
    key_exit=Escape
    cache_timeout=86400
    sort_order=alphabetical
    hide_scroll=true
    dynamic_lines=false
    parse_search=false
    single_click=true
  '';

  home.file.".config/wofi/style.css".text = ''
    * {
        font-family: "JetBrains Mono", monospace;
        font-weight: 500;
        font-size: 12px;
    }

    window {
        margin: 0px;
        border-radius: 15px;
        background: rgba(40, 42, 54, 0.95);
        border: 2px solid rgba(189, 147, 249, 0.3);
        animation: fadeIn 0.1s ease-out;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: scale(0.98); }
        to { opacity: 1; transform: scale(1); }
    }

    #input {
        margin: 10px 15px 5px 15px;
        border: 1px solid rgba(98, 114, 164, 0.4);
        background: rgba(68, 71, 90, 0.6);
        color: #f8f8f2;
        border-radius: 10px;
        font-size: 14px;
        padding: 10px 15px;
        transition: all 0.15s ease;
    }

    #input:focus {
        border-color: rgba(189, 147, 249, 0.8);
        background: rgba(68, 71, 90, 0.8);
    }

    #inner-box {
        margin: 5px 15px 15px 15px;
        background: transparent;
        border-radius: 10px;
    }

    #scroll {
        margin: 0px;
        border: none;
        background: transparent;
        padding: 0px;
    }

    #entry {
        background: rgba(68, 71, 90, 0.3);
        margin: 2px 4px;
        padding: 10px 15px;
        border-radius: 8px;
        border: 1px solid rgba(98, 114, 164, 0.2);
        transition: all 0.1s ease;
        min-height: 40px;
        display: flex;
        align-items: center;
    }

    #entry:hover {
        background: rgba(98, 114, 164, 0.4);
        border-color: rgba(189, 147, 249, 0.6);
        transform: translateY(-1px);
    }

    #entry:selected {
        background: rgba(189, 147, 249, 0.3);
        border-color: rgba(189, 147, 249, 0.8);
        transform: translateY(-1px);
    }

    #entry #img {
        margin-right: 10px;
        border-radius: 6px;
        transition: all 0.1s ease;
    }

    #entry:hover #img {
        transform: scale(1.02);
    }

    #text {
        color: #f8f8f2;
        font-size: 13px;
        font-weight: 500;
        flex: 1;
        margin: 0;
        padding: 0;
    }

    #entry:hover #text {
        color: #ffffff;
    }

    #entry:selected #text {
        color: #ffffff;
        font-weight: 600;
    }
  '';

  # ===== WAYBAR CONFIGURATION (PERFORMANCE OPTIMIZED) =====
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;
        
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces" 
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "tray"
          "custom/power"
        ];

        "custom/launcher" = {
          format = " ";
          on-click = "wofi --show drun";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };

        clock = {
          timezone = "America/New_York";
          format = "{:%I:%M %p}";  # Changed from %H:%M to %I:%M %p for 12-hour format
          format-alt = "{:%a %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 60;
        };

        pulseaudio = {
          scroll-step = 5;
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          format-icons = ["" "" ""];
          on-click = "pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip = false;
        };

        network = {
          interval = 5;
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          max-length = 20;
          on-click = "nm-connection-editor";
          tooltip = false;
        };

        cpu = {
          interval = 3;
          format = "󰍛 {usage}%";
          max-length = 10;
          on-click = "kitty --class btop -e btop";
          tooltip = false;
        };

        memory = {
          interval = 3;
          format = "󰾆 {percentage}%";
          on-click = "kitty --class btop -e btop";
          tooltip = false;
        };

        battery = {
          interval = 30;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          on-click = "power-menu-battery";
          on-click-right = "tlp-toggle-mode";
          tooltip = false;
        };

        tray = {
          icon-size = 14;
          spacing = 4;
          show-passive-items = true;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
          on-click-right = "systemctl poweroff";
        };
      };
    };

    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrains Mono", monospace;
          font-size: 11px;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      window#waybar {
          background: transparent;
          color: #f8f8f2;
      }

      .modules-left,
      .modules-center,
      .modules-right {
          background: rgba(40, 42, 54, 0.85);
          border-radius: 12px;
          margin: 0 4px;
          padding: 0 4px;
          border: 1px solid rgba(68, 71, 90, 0.5);
      }

      .modules-left > widget:first-child > #workspaces,
      .modules-center > widget > #clock,
      .modules-right > widget > * {
          margin: 0 2px;
          padding: 4px 8px;
          border-radius: 8px;
          background: transparent;
          transition: all 0.15s ease;
      }

      #workspaces button {
          padding: 4px 8px;
          margin: 0 1px;
          background: transparent;
          color: #6272a4;
          border-radius: 6px;
          transition: all 0.15s ease;
          min-width: 20px;
      }

      #workspaces button.active {
          background: rgba(189, 147, 249, 0.3);
          color: #bd93f9;
      }

      #clock { color: #f8f8f2; }
      #pulseaudio { color: #ff79c6; }
      #network { color: #50fa7b; }
      #cpu { color: #ffb86c; }
      #memory { color: #ff79c6; }
      #battery { color: #50fa7b; }
      #custom-power { color: #ff5555; }

      #battery.charging { color: #f1fa8c; }
      #battery.warning:not(.charging) { color: #ffb86c; }
      #battery.critical:not(.charging) { color: #ff5555; }
    '';
  };

  # ===== GTK CONFIGURATION =====
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Inter";
      size = 13;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 40;
      gtk-enable-animations = false;
      gtk-primary-button-warps-slider = false;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 40;
    };
  };

  # ===== XDG CONFIGURATION =====
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      templates = "$HOME/Templates";
      publicShare = "$HOME/Public";
    };
    
    # MIME type associations - temporarily disabled to fix backup conflicts
    # mimeApps = {
    #   enable = true;
    #   defaultApplications = {
    #     "text/html" = "firefox.desktop";
    #     "x-scheme-handler/http" = "firefox.desktop";
    #     "x-scheme-handler/https" = "firefox.desktop";
    #     "x-scheme-handler/about" = "firefox.desktop";
    #     "x-scheme-handler/unknown" = "firefox.desktop";
    #     "application/pdf" = "firefox.desktop";
    #     "image/jpeg" = "org.gnome.eog.desktop";
    #     "image/png" = "org.gnome.eog.desktop";
    #     "text/plain" = "code.desktop";
    #     "inode/directory" = "thunar.desktop";
    #   };
    # };
  };

  # ===== ADDITIONAL CONFIGURATION FILES =====
  # Hyprpaper configuration with fallback wallpaper
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/wallpaper.png
    wallpaper = ,~/.config/hypr/wallpaper.png
    splash = false
    ipc = on
  '';

  # Create a default wallpaper if none exists
  home.file.".config/hypr/wallpaper.jpg".source = let
    # Create a simple gradient wallpaper using imagemagick
    defaultWallpaper = pkgs.runCommand "default-wallpaper.jpg" 
      { buildInputs = [ pkgs.imagemagick ]; } ''
      ${pkgs.imagemagick}/bin/convert -size 2256x1504 gradient:"#282a36-#44475a" $out
    '';
  in defaultWallpaper;

  # Swaylock configuration
  home.file.".config/swaylock/config".text = ''
    image=~/.config/hypr/wallpaper.png
    scaling=fill
    font=JetBrains Mono
    font-size=24
    indicator-radius=120
    indicator-thickness=10
    key-hl-color=bd93f9
    separator-color=44475a
    inside-color=282a36
    ring-color=6272a4
    line-color=282a36
    text-color=f8f8f2
    caps-lock-key-hl-color=ff5555
    caps-lock-bs-hl-color=ff5555
    disable-caps-lock-text
    show-failed-attempts
    fade-in=0.2
  '';

  # Wlogout layout
  home.file.".config/wlogout/layout".text = ''
    [
        {
            "label" : "lock",
            "action" : "swaylock",
            "text" : "Lock",
            "keybind" : "l"
        },
        {
            "label" : "hibernate",
            "action" : "systemctl hibernate",
            "text" : "Hibernate",
            "keybind" : "h"
        },
        {
            "label" : "logout",
            "action" : "hyprctl dispatch exit",
            "text" : "Logout",
            "keybind" : "e"
        },
        {
            "label" : "shutdown",
            "action" : "systemctl poweroff",
            "text" : "Shutdown",
            "keybind" : "s"
        },
        {
            "label" : "suspend",
            "action" : "systemctl suspend",
            "text" : "Sleep",
            "keybind" : "u"
        },
        {
            "label" : "reboot",
            "action" : "systemctl reboot",
            "text" : "Reboot",
            "keybind" : "r"
        }
    ]
  '';

  # Wlogout styling
  home.file.".config/wlogout/style.css".text = ''
    * {
      background-image: none;
      box-shadow: none;
    }

    window {
      background-color: rgba(40, 42, 54, 0.9);
    }

    button {
        color: #f8f8f2;
      background-color: #44475a;
      border-style: solid;
      border-width: 3px;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
      border-radius: 20px;
      margin: 10px;
      transition: all 0.3s ease-in-out;
    }

    button:focus, button:active, button:hover {
      background-color: #6272a4;
      border-color: #bd93f9;
      outline-style: none;
      transform: scale(1.05);
    }

    #lock {
        border-color: #50fa7b;
    }

    #logout {
        border-color: #f1fa8c;
    }

    #suspend {
        border-color: #8be9fd;
    }

    #hibernate {
        border-color: #ffb86c;
    }

    #shutdown {
        border-color: #ff5555;
    }

    #reboot {
        border-color: #ff79c6;
    }
  '';

  # ===== HOME PACKAGES =====
  home.packages = with pkgs; [
    # Gesture support
    libinput-gestures
    wmctrl
    xdotool
    
    # Additional utilities
    bc
    acpi
    upower
    
    # Development tools
    nil  # Nix language server
    
    # Media tools
    playerctl
    
    # File management
    trash-cli
    
    # Performance monitoring
    iotop
    nethogs
  ];

  # ===== SYSTEMD USER SERVICES =====
  systemd.user.services = {
    # Auto-start libinput-gestures
    libinput-gestures = {
      Unit = {
        Description = "Libinput Gestures";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Clipboard history daemon
    cliphist = {
      Unit = {
        Description = "Clipboard History";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.cliphist}/bin/cliphist daemon";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Waybar service
    waybar = {
      Unit = {
        Description = "Waybar";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        RestartSec = 3;
        KillMode = "mixed";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  # ===== PROGRAM CONFIGURATIONS =====
  # Git configuration
  programs.git = {
    enable = true;
    userName = "dylan";
    userEmail = "dylan@example.com";  # Update with your email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "code --wait";
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
    
    shellAliases = {
      ll = "eza -la";
      la = "eza -la";
      ls = "eza";
      tree = "eza --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      
      # Hyprland specific
      hypr-reload = "hyprctl reload";
      hypr-logs = "journalctl -u display-manager -f";
      
      # Btop wallpaper aliases
      btop-start = "btop-wallpaper start";
      btop-stop = "btop-wallpaper stop";
      btop-toggle = "btop-wallpaper toggle";
      
      # System monitoring
      temps = "sensors";
      battery = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      
      # Performance
      performance = "hypr-performance";
    };
    
    bashrcExtra = ''
      # Framework 13 specific optimizations
      export EDITOR="code --wait"
      export BROWSER="firefox"
      export TERMINAL="kitty"
      
      # Path additions
      export PATH="$HOME/.local/bin:$PATH"
      
      # Performance optimizations
      export HISTCONTROL=ignoreboth
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      
      # Wayland specific
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      
      # Custom functions
      function hypr-screen() {
        grim -g "$(slurp)" ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png
      }
      
      function hypr-record() {
        wf-recorder -g "$(slurp)" -f ~/Videos/recording-$(date +%Y-%m-%d_%H-%M-%S).mp4
      }
      
      function wofi-calc() {
        echo "$(($1))" | wl-copy
        notify-send "Calculator" "Result: $(($1)) (copied to clipboard)"
      }
    '';
  };

  # Starship prompt (optional, for a modern terminal prompt)
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        style = "blue";
        truncation_length = 3;
        truncate_to_repo = false;
      };
      git_branch = {
        style = "purple";
        format = "[$symbol$branch]($style) ";
      };
      battery = {
        display = [
          {
            threshold = 30;
            style = "bold red";
          }
          {
            threshold = 60;
            style = "bold yellow";
          }
          {
            threshold = 100;
            style = "bold green";
          }
        ];
      };
    };
  };

  # ===== PERFORMANCE MONITORING ALIASES =====
  home.sessionVariables = {
    EDITOR = "code --wait";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    
    # Wayland specific
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    
    # Performance
    HISTCONTROL = "ignoreboth";
    HISTSIZE = "10000";
    HISTFILESIZE = "20000";
  };

  # ===== FONTS CONFIGURATION =====
  fonts.fontconfig.enable = true;

  # ===== ADDITIONAL SCRIPTS FOR HOME =====
  home.file.".local/bin/hypr-info" = {
    text = ''
      #!/bin/bash
      # Comprehensive Hyprland system information
      echo "=== Hyprland System Information ==="
      echo "Date: $(date)"
      echo "Uptime: $(uptime -p)"
      echo ""
      
      echo "=== Hyprland Status ==="
      if pgrep -x Hyprland >/dev/null; then
        echo "✅ Hyprland is running"
        echo "Version: $(hyprctl version | head -1)"
        echo "Active window: $(hyprctl activewindow | grep class | cut -d: -f2)"
        echo "Workspace: $(hyprctl activeworkspace | grep workspace | cut -d: -f2)"
      else
        echo "❌ Hyprland is not running"
      fi
      echo ""
      
      echo "=== Plugin Status ==="
      hyprctl plugin list 2>/dev/null || echo "No plugins loaded or hyprctl unavailable"
      echo ""
      
      echo "=== Performance ==="
      echo "Load: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')"
      echo "Memory: $(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')%"
      echo "Disk: $(df -h / | tail -1 | awk '{print $5}')"
      echo ""
      
      echo "=== Display Info ==="
      echo "Monitors: $(hyprctl monitors | grep Monitor | wc -l)"
      echo "Resolution: $(hyprctl monitors | grep -m1 '@' | awk '{print $1}' | cut -d'@' -f1)"
      echo "Scale: $(hyprctl monitors | grep -m1 'scale:' | awk '{print $2}')"
    '';
    executable = true;
  };

  home.file.".local/bin/btop-wallpaper" = {
    text = ''
      #!/bin/bash
      # Btop wallpaper manager - using floating terminal approach
      
      show_help() {
        echo "Btop Wallpaper Manager for Framework 13"
        echo "Usage: btop-wallpaper [command] [options]"
        echo ""
        echo "Commands:"
        echo "  start [position]  - Start btop monitor"
        echo "  stop             - Stop btop monitor"
        echo "  restart [pos]    - Restart btop monitor"
        echo "  status           - Show current status"
        echo "  toggle           - Toggle btop monitor on/off"
      }
      
      start_btop() {
        local position=''${1:-center}
        
        # Kill existing instance
        pkill -f "kitty.*btop-wallpaper" 2>/dev/null || true
        sleep 0.5
        
        # Launch btop in floating terminal with wallpaper-like properties
        hyprctl dispatch exec "kitty --class btop-wallpaper -o font_size=11 -o background_opacity=0.8 -o window_padding_width=8 -e btop"
        
        # Wait and position the window
        sleep 2
        case $position in
          "corner")
            hyprctl dispatch movewindowpixel "exact 800 30,class:btop-wallpaper"
            hyprctl dispatch resizewindowpixel "exact 600 400,class:btop-wallpaper"
            ;;
          "left")
            hyprctl dispatch movewindowpixel "exact 30 30,class:btop-wallpaper"
            hyprctl dispatch resizewindowpixel "exact 600 500,class:btop-wallpaper"
            ;;
          "right")
            hyprctl dispatch movewindowpixel "exact 780 30,class:btop-wallpaper"
            hyprctl dispatch resizewindowpixel "exact 600 500,class:btop-wallpaper"
            ;;
          *)
            hyprctl dispatch movewindowpixel "exact 350 220,class:btop-wallpaper"
            hyprctl dispatch resizewindowpixel "exact 700 500,class:btop-wallpaper"
            ;;
        esac
        
        # Verify it started
        sleep 1
        if pgrep -f "kitty.*btop-wallpaper" >/dev/null; then
          notify-send "Btop Monitor" "Started in $position position" --timeout=2000
        else
          notify-send "Btop Monitor" "Failed to start" --urgency=critical
        fi
      }
      
      stop_btop() {
        if pkill -f "kitty.*btop-wallpaper" 2>/dev/null; then
          notify-send "Btop Monitor" "Stopped" --timeout=2000
        else
          echo "No btop monitor instance found"
        fi
      }
      
      show_status() {
        if pgrep -f "kitty.*btop-wallpaper" >/dev/null; then
          echo "✅ Btop monitor is running"
          hyprctl clients | grep -A 5 "btop-wallpaper" || echo "Window info not available"
        else
          echo "❌ Btop monitor is not running"
        fi
      }
      
      toggle_btop() {
        if pgrep -f "kitty.*btop-wallpaper" >/dev/null; then
          stop_btop
        else
          start_btop center
        fi
      }
      
      case "$1" in
        "start")
          start_btop "$2"
          ;;
        "stop")
          stop_btop
          ;;
        "restart")
          stop_btop
          sleep 1
          start_btop "$2"
          ;;
        "status")
          show_status
          ;;
        "toggle")
          toggle_btop
          ;;
        *)
          show_help
          ;;
      esac
    '';
    executable = true;
  };

  home.file.".local/bin/debug-autostart" = {
    text = ''
      #!/bin/bash
      # Debug script to check autostart issues
      
      echo "=== Autostart Debug Information ==="
      echo "Date: $(date)"
      echo ""
      
      echo "=== Process Check ==="
      echo "Hyprland running: $(pgrep -x Hyprland >/dev/null && echo "✅ Yes" || echo "❌ No")"
      echo "Waybar running: $(pgrep -x waybar >/dev/null && echo "✅ Yes" || echo "❌ No")"
      echo "Hyprpaper running: $(pgrep -x hyprpaper >/dev/null && echo "✅ Yes" || echo "❌ No")"
      echo "Btop wallpaper: $(pgrep -f "kitty.*btop-wallpaper" >/dev/null && echo "✅ Running" || echo "❌ Not running")"
      echo ""
      
      echo "=== File Check ==="
      echo "Wallpaper exists: $([ -f ~/.config/hypr/wallpaper.jpg ] && echo "✅ Yes" || echo "❌ No")"
      echo "Hyprpaper config: $([ -f ~/.config/hypr/hyprpaper.conf ] && echo "✅ Yes" || echo "❌ No")"
      echo "Autostart script: $([ -f ~/.local/bin/btop-wallpaper-autostart ] && echo "✅ Yes" || echo "❌ No")"
      echo ""
      
      echo "=== Script Permissions ==="
      ls -la ~/.local/bin/btop-wallpaper* 2>/dev/null || echo "Scripts not found"
      echo ""
      
      echo "=== Manual Test ==="
      echo "Testing btop wallpaper manually..."
      btop-wallpaper start &
      sleep 3
      if pgrep -f "kitty.*btop-wallpaper" >/dev/null; then
        echo "✅ Manual start successful"
        btop-wallpaper stop
      else
        echo "❌ Manual start failed"
      fi
      echo ""
      
      echo "=== Hyprland Windows ==="
      hyprctl clients | grep -E "(class|title|workspace)" | head -10
    '';
    executable = true;
  };

  # ===== FINAL HOME MANAGER CONFIGURATION =====
  # This ensures all configurations are properly applied
  home.activation = {
    # Create necessary directories
    createDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.local/bin
      mkdir -p $HOME/Pictures/Screenshots
      mkdir -p $HOME/Videos
      mkdir -p $HOME/.cache
    '';
  };
}
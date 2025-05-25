# NixOS built for Framework 13 AMD

This is my NixOS config for the Framework 13, AMD Ryzen 5 7640U

**Optimized with 1.666667x (167%) scaling for perfect readability on old Framework 13 3:2 display**

```
 _____________________________
< now with 1.666667x scaling! >
 -----------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Features

- **Hyprland Wayland compositor** with optimized 167% scaling
- **Dracula theme** consistently applied across WM, terminal, and applications
- **Framework 13 AMD specific optimizations** for hardware compatibility
- **Perfect scaling** for Firefox, VS Code, Wofi, and all applications
- **AMD GPU acceleration** with proper drivers and power management

## Installation

1. Clone this repository
   ```bash
   git clone <your-repo-url>
   cd nixos-framework-config
   ```

2. Copy files to /etc/nixos/ or use flakes (recommended)
   ```bash
   sudo nixos-rebuild switch --flake .#framework
   ```

3. Log out and back in to apply all scaling changes

## Components

### Desktop Environment
- **Hyprland** (Wayland compositor) - 167% scaling optimized
- **Waybar** (status bar) - Modern design with proper scaling
- **Wofi** (application launcher) - Large fonts and better UX
- **SDDM** with MineSDDM theme - Login manager

### Applications
- **Kitty** (terminal) - Font size 16 for perfect readability
- **Ghostty** (alternative terminal)
- **Firefox** - Proper 167% UI scaling with enhanced settings
- **VS Code** - Font size 18 with 67% zoom level
- **Vim/Neovim** (editors)

### System Tools
- **TLP** - Advanced power management for Framework 13
- **PipeWire** - Modern audio system
- **NetworkManager** - Network management
- **Bluetooth** - Full Bluetooth support

### File Management
- **lf** (terminal file browser)
- **Thunar** (GUI file manager)

## Scaling Configuration

This configuration uses **1.666667x (167%) scaling** which provides:
- ✅ Perfect Firefox text and UI scaling
- ✅ Crisp application launcher (Wofi)
- ✅ Readable system fonts across all applications
- ✅ Properly sized cursors (48px)
- ✅ Appropriate window gaps and borders

### Key Scaling Settings:
- **Monitor scaling**: 1.666667
- **GDK_SCALE**: 1.666667
- **QT_SCALE_FACTOR**: 1.666667  
- **Firefox devPixelsPerPx**: 1.666667
- **Cursor size**: 48px

## Framework 13 Optimizations

- **AMD-specific kernel parameters** for better performance
- **Proper power management** with TLP configuration
- **Battery charge thresholds** (75%-90% for longevity)
- **Framework function key support** (brightness, volume)
- **Optimized touchpad settings** for 3:2 display
- **AMD GPU acceleration** with ROCm support

## Troubleshooting

### Scaling Issues
If applications don't scale properly:
1. Log out and back in after rebuild
2. For specific apps, you can override with: `env GDK_SCALE=1.666667 <app>`

### Build Issues
- Ensure all deprecated warnings are resolved
- Check that `modules/home.nix` has proper Nix syntax
- Use `--show-trace` for detailed error information

## Contributing

Feel free to open issues or submit PRs for improvements. This config is specifically optimized for the Framework 13 AMD but could be adapted for other HiDPI displays.

## License

MIT License - See LICENSE file for details
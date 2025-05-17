{ config, lib, pkgs, ... }:

{
  # Framework 13 AMD specific configuration
  
  # Better touchpad configuration
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = false;
      naturalScrolling = true;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
      accelSpeed = "0.3"; # Adjust to preference
    };
  };
  
  # Better graphics driver configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };
  
  # Enable kernel module for Framework expansion cards if needed
  boot.kernelModules = [ "kvm-amd" ];

  # Framework specific kernel parameters
  boot.kernelParams = [ 
    "amd_pstate=active"
    "nvme.noacpi=1"
    "acpi_osi=Linux"
    "acpi_backlight=native"
  ];
  
  # Enable S3 sleep state
  boot.extraModprobeConfig = ''
    options amdgpu deep_color=1
    options amdgpu dc=1
    options amdgpu hwmon=1
  '';
}
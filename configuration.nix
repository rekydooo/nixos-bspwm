{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/games.nix
      ./modules/graphics.nix
    ];

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "udev.log_level=0"
      "intel_pstate=disable"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        editor = false;
      };
      timeout = 2;
      grub.enable = false;
      efi = {
        canTouchEfiVariables = true; 
      };
    };
    kernelPackages = pkgs.linuxPackages;
  };

  time.timeZone = "Europe/Kyiv";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking = {
    hostName = "nixos";

    networkmanager = {
      enable = true;
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [ 27036 ];
      allowedUDPPorts = [ 27031 27036 7777 ];
    };
  };

  hardware.enableRedistributableFirmware = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.kyd0 = {
    isNormalUser = true;
    description = "Denys";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  services.xserver = {
    enable = true;

    xkb.layout = "us, ua";
    xkb.variant = "";
    xkb.options = "grp:alt_shift_toggle";
    
    desktopManager.xterm.enable = false;

    windowManager.bspwm = {
      enable = true;
    };

    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk.enable = true;
      };
    };
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  programs.zsh = {
    enable = true;

    ohMyZsh = {
      enable = true;

      plugins = [
        "git"
	"python"
	"sudo"
      ];
      theme = "peepcode";
    };

    syntaxHighlighting.enable = true;
    shellAliases = {
      bs = "sudo nvim /home/kyd0/.config/bspwm/bspwmrc";
      sx = "sudo nvim /home/kyd0/.config/sxhkd/sxhkdrc";
      nx = "sudo nvim /etc/nixos/configuration.nix";
      rb = "sudo nixos-rebuild switch";
      cnx = "sudo nix-collect-garbage -d";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    defaultEditor = true;

    withPython3 = true;
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball "https://github.com/PolyMC/PolyMC/archive/develop.tar.gz")).overlay
  ];

  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    polybar
    picom
    feh
    rofi
    dunst
    scrot

    xsel
    xclip
    xdotool

    bibata-cursors

    alacritty

    nerdfetch

    git
    wget
    curl
    unzip

    lua

    pyright
    ruff
    mypy
    rust-analyzer

    tree-sitter

    librewolf
    chromium

    nemo

    python3
    gcc
    clang
    clang-tools
    cmake
    ninja
    gdb
    openjdk17
    nodejs
    nodePackages.npm
    ripgrep
    fd

    mangohud
    lm_sensors
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers

    taterclient-ddnet
    polymc
    wineWowPackages.staging
    winetricks
    lutris

    blender
    legcord

    maxima
    wxmaxima
    drawio

    jhentai

    via
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "/home/kyd0/.config";
    XDG_DATA_HOME = "/home/kyd0/.local/share";
    XDG_CACHE_HOME = "/home/kyd0/.cache";

    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "16";
  };

  services.udev.extraRules = ''
    KERNEL=="hidraw*", MODE="0666"
  '';

  services.fstrim.enable = true;

  system.stateVersion = "25.11";

}

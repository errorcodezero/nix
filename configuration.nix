# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-b5ffad76-86bc-4f81-91a7-03b2faa7f772".device = "/dev/disk/by-uuid/b5ffad76-86bc-4f81-91a7-03b2faa7f772";
  boot.initrd.luks.devices."luks-b5ffad76-86bc-4f81-91a7-03b2faa7f772".keyFile = "/crypto_keyfile.bin";


  # Stupid broadcom driver
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  boot.initrd.kernelModules = [ "wl" ];

  networking.hostName = "errorcodezero"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.errorcodezero = {
    isNormalUser = true;
    description = "ErrorCode0";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ 
      pkgs.neofetch 
      pkgs.tmux 
      pkgs.grim
      pkgs.slurp
      pkgs.discord
      pkgs.onlyoffice-bin
      pkgs._1password-gui
      pkgs._1password
      pkgs.btop
      pkgs.thunderbird
      pkgs.cowsay
      pkgs.cmatrix
      pkgs.lolcat
      pkgs.nodejs_18
      pkgs.nodePackages.pnpm
      pkgs.anki
      pkgs.signal-desktop
      pkgs.obsidian
      pkgs.steam
      pkgs.prismlauncher
      pkgs.catppuccin-kde
      pkgs.python3
      pkgs.python310Packages.pip
    ];
  };

  services.syncthing = {
     enable = true;
     user = "errorcodezero";
     dataDir = "/home/errorcodezero/Sync";
     configDir = "/home/errorcodezero/Sync/.config/";
  };

  fonts.fonts = with pkgs; [
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    firefox
    chromium
    pkgs.hyprpaper
    pkgs.chezmoi
    pkgs.kitty
    pkgs.rofi-wayland
    pkgs.waybar
    pkgs.pamixer
    pkgs.mako
    pkgs.libnotify
    pkgs.wlr-randr
    pkgs.gcc
    pkgs.ripgrep
    pkgs.qbittorrent
    pkgs.brightnessctl
    pkgs.gh
    pkgs.imagemagick
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.hyprland.enable = true;

  system.stateVersion = "23.05";
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  # Red
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Zona horaria e idioma
  time.timeZone = "America/Santiago";

  i18n.defaultLocale = "es_CL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Teclado
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  #Services

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Gráfico base estable
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # NVIDIA explícito para tu RTX 4060
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;

  # Audio / impresión
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

 
  security.rtkit.enable = true;

  # Usuario
  users.users.reyben = {
    isNormalUser = true;
    description = "Reyben";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Unfree
  nixpkgs.config.allowUnfree = true;

  # Programas base
  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.nix-ld.enable = true;
  programs.hyprland.enable = true;
  xdg.portal.enable = true;

  # Steam
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;

  # AppImage y binarios externos
  programs.appimage.enable = true;

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  ];


  environment.systemPackages = with pkgs; [
    # base
    starship
    cliphist
    wlogout
    mangohud
    mpvpaper
    grim
    slurp
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    hyprpaper
    hyprlock
    hypridle
    dunst
    wl-clipboard
    waybar
    wget
    curl
    git
    neovim
    vim
    unzip
    zip
    p7zip
    htop
    btop
    tree
    file
    which
    killall
    fastfetch
    kitty
    rofi

    # escritorio
    firefox
    discord
    libreoffice
    vlc
    gimp
    obs-studio
    filezilla

    # desarrollo
    vscode
    github-desktop
    gitkraken
    jq
    gcc
    gnumake
    python3

    # compresión / discos / red
    usbutils
    pciutils
    ntfs3g

    # hyprland helpers
    pavucontrol
    blueman

];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}

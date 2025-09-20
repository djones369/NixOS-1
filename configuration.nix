# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #--- Updated Kernel ---#
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "busy-bee"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dave = {
    isNormalUser = true;
    description = "Dave J";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "libvirtd" "video" "render" "audio" ];
    packages = with pkgs; [
    thunderbird
    rustdesk-flutter
    rustdesk-server
    ];
  };


  environment.variables.PATH = [
    "${config.users.users.dave.home}/.emacs.d/bin"
  ];


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #--- Tailscale Services ---#
  # services.tailscale.enable = true;
  # services.tailscale.package = pkgs.tailscale.overrideAttrs (_: { doCheck = false; });
  # networking.nftables.enable = true;
  # services.tailscale.useRoutingFeatures = "server"; # or "client"

### RustDesk Server Info for NixOS

  # Rustdesk Background Service
  systemd.user.services.rustdesk = {
  description = "RustDesk Remote Desktop Service";
  after = [ "network.target" ];
  serviceConfig = {
    # ExecStart = "/run/current-system/sw/bin/rustdesk --service";
    ExecStart = "rustdesk --service";
    Restart = "always";
    RestartSec = 5;
  };
  wantedBy = [ "default.target" ];
};

virtualisation.spiceUSBRedirection.enable = true;

  # --- Enable Flatpak  ---
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # --- Flatpak auto-update ---
  systemd.services."flatpak-update" = {
    description = "Update Flatpak applications";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update -y";
    };
  };

  systemd.timers."flatpak-update" = {
    description = "Run Flatpak update daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
  # --- End Flatpak auto-update ---

  # Enable Nix experimental features and Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     gnome-software
     wget
     htop
     # pkgs.tailscale
     # (pkgs.tailscale.overrideAttrs (_: { doCheck = false; }))
     pciutils
     yt-dlp
     pkgs.cifs-utils
     pkgs.samba
     nmap
     appimage-run
     git
     github-desktop
     gnumake
     unzip
     zip
     google-chrome
     gnupg
     distrobox
     kitty
     xorg.libXrandr
     xorg.libxcb
     ffmpeg-full
     libevdev
     libpulseaudio
     xorg.libX11
     pkgs.xorg.libxcb
     xorg.libXfixes
     libva
     libvdpau
     telegram-desktop
     mpv
     xdotool
     pwvucontrol
     easyeffects
     pipecontrol
     wireplumber
     pavucontrol
     ncpamixer
     carla
     vlc
     neovim
     vimPlugins.LazyVim
     gh
     gitui
     cmake
     ispell
     gcc
     go
     geany
     vscode
     virt-manager
     fastfetch
     ghostty
     bitwarden-desktop
     nerd-fonts.symbols-only
     boxbuddy
     mate.mate-terminal
     fastfetch
     starship
     hexo-cli
     hugo
     jekyll
     ghost-cli
     marp-cli
     mumble
     nil
     zed-editor
     discord
     remmina
     tshark
     wireshark
     obsidian
     gimp3-with-plugins
     tor
     tor-browser
     brave

# --- (Doom) Emacs --- #
     emacs
     ripgrep
     # optional dependencies
     coreutils # basic GNU utilities
     fd
     clang
     emacsPackages.doom
     emacsPackages.doom-themes
     gnupg

     # Markdown
     pandoc
     # Shell
     shellcheck
     # Org export
     texlive.combined.scheme-small
     # Extras
     imagemagick sqlite aspell

  ];

# --- Weekly Garbage CLeaner --- #

  # If you use systemd-boot:
  boot.loader.systemd-boot.configurationLimit = 5;

  # Automatic garbage collection (adjust schedule/retention as you like)
  nix.gc = {
    automatic = true;
    dates = "weekly";                 # or "monthly", "daily", "Sat 03:00", etc.
    options = "--delete-older-than 14d";
  };

# ---  Keep the /nix/store tidy automatically --- #
  nix.settings.auto-optimise-store = true;



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}


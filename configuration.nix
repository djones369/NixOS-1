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

  networking.hostName = "Master-Nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts =
    ''
      staging.wflib.org 100.100.146.88
    '';

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

  # Optionally, enable the OpenGL library for hardware acceleration
  # hardware.opengl.enable = true;
  hardware.graphics.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;
  # services.xserver.desktopManager.budgie.package = pkgs.budgie-desktop-with-plugins;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "adbusers" "libvirtd" "kvm" "video" "render" "audio" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable tailscale
  services.tailscale.enable = true;

  #----=[ Fonts ]=----#
  fonts.packages = with pkgs; [
    noto-fonts
    ubuntu_font_family
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    fira
    nerdfonts
  ];

  # Lets get Fish Shell - CF 6-1-22
  programs.fish.enable = true;

  # Flatpak bitches - CF 6-1-22
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Nix experimental features and Flakes 4-17-24
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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

  # Rustdesk Background Service
  systemd.user.services.rustdesk = {
  description = "RustDesk Remote Desktop Service";
  after = [ "network.target" ];
  serviceConfig = {
    ExecStart = "/run/current-system/sw/bin/rustdesk --service";
    Restart = "always";
    RestartSec = 5;
  };
  wantedBy = [ "default.target" ];
};



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

  # Accessories
  btop              # Resource monitor
  dunst             # Notification daemon
  fastfetch         # System information fetcher
  filezilla         # Graphical FTP, FTPS and SFTP client
  htop              # System monitor
  rpi-imager        # Raspberry Pi Imaging Utility
  starship	    # customizable prompt for any shell
  ventoy            # USB boot tool


  # Graphics
  xorg.libX11       # Core X11 library
  xorg.libxcb       # Alternative variant of libxcb
  xorg.libXfixes    # X11 library for miscellaneous fixes
  xorg.libXrandr    # X11 library for screen resizing/rotation
  gimp-with-plugins # GNU Image Manipulation Program
  inkscape-with-extensions # Vector graphics editor


  # Internet
  brave		    # Privacy-oriented browser for Desktop and Laptop computers
  cockpit			# Web-based graphical interface for servers
  discord           # All-in-one cross-platform voice and text chat for gamers
  distrobox         # Containerized environment manager
  docker-compose	# define and run multi-container applications with Docker
  google-chrome     # Web browser
  nmap              # Network scanner
  podman			# Program for managing pods, containers and container images
  podman-compose	# Implementation of docker-compose with podman backend
  podman-desktop	# A graphical tool for developing on containers and Kubernetes
  tailscale         # VPN tool for secure network access
  runelite          # Open source Old School RuneScape client
  wget              # Command-line file downloader
  yt-dlp            # YouTube (and more) downloader
  transmission_4    # Fast, easy and free BitTorrent client
  wireshark         # Powerful network protocol analyzer
  # pcloud            # Cloud Storage (Not Working)

  # Office
  libreoffice-fresh # Latest version of LibreOffice
  # logseq	    # outliner notebook for organizing and sharing your personal knowledge base
  novelwriter       # Open source plain text editor designed for writing novels
  obsidian          # Powerful knowledge base that works on top of a local folder of plain text Markdown files
  scribus           # Desktop Publishing (DTP) and Layout program
  typora            # Markdown editor for document editing

  # Programming
  cmake             # Build system
  gcc               # Compiler collection
  geany             # Lightweight IDE/editor
  gh                # GitHub CLI
  git               # Version control
  gitui             # Terminal UI for Git
  go                # Programming language
  godot_4           # Free and Open Source 2D and 3D game engine
  gnumake           # Build automation tool
  hexo-cli	    # Command line interface for Hexo
  hugo		    # Fast and modern static website engine
  ispell            # Spell checker
  neovim            # Text editor
  nodejs_23	    # framework for the V8 JavaScript engine
  vimPlugins.LazyVim  # Enhanced Vim configuration
  vscode            # Code editor

  # Sound and Video
  audacity          # Sound editor with graphical UI
  blender-hip       # 3D Creation/Animation/Publishing System
  carla             # Audio plugin host
  cheese            # Take photos and videos with your webcam, with fun graphical effects
  easyeffects       # Audio effects processor
  ffmpeg-full       # Multimedia framework
  flameshot         # Powerful yet simple to use screenshot software
  handbrake         # Tool for converting video files and ripping DVDs
  haruna            # Audio player
  libevdev          # Input device library
  libpulseaudio     # Audio management
  libva             # Video acceleration API
  libvdpau          # Video acceleration for VDPAU
  mumble            # Low-latency, high quality voice chat software
  mpv               # Media player
  ncpamixer         # Mixer utility
  obs-studio        # Free and open source software for video recording and live streaming
  pavucontrol      # PulseAudio volume control
  pipecontrol       # Media pipeline tool
  pwvucontrol       # Volume control utility
  shotcut           # Free, open source, cross-platform video editor
  trayscale       # (Media tool – adjust placement if needed)
  vlc               # Multimedia player
  wireplumber       # Audio session manager

  # System Tools
  angryipscanner    # IP Scanner (That's ANGRY!)
  appimage-run      # Run AppImage applications
  bitwarden-desktop # Password manager
  clamav            # Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats
  clamtk            # lightweight front-end for ClamAV (Clam Antivirus)
  gnome-boxes       # Simple GNOME 3 application to access remote or virtual systems
  gnome-disk-utility # Udisks graphical front-end
  gnupg             # Encryption and signing tool
  jmtpfs            # Mount MTP devices
  kitty             # Terminal emulator (GPU-accelerated)
  pciutils          # Hardware info utility
  pika-backup       # Simple backups based on borg
  pkgs.samba        # SMB server/client tools
  remmina           # Remote desktop client written in GTK
  syncthing         # Open Source Continuous File Synchronization
  syncthing-tray    # Simple application tray for syncthing
  virt-manager      # Virtualization manager
  xdotool           # X11 automation utility
  unzip             # Archive extraction tool
  zip               # Archive compression tool
  hplipWithPlugin   # HP Printer Drivers
  warp-terminal     # Fast terminal with AI

  # Rustdesk
  rustdesk-flutter
  rustdesk-server

  ];

  # Unstable Apps

  # Service to start

  # Enable Auto Optimising the store
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    # options = "--keep-generations 5";
    options = "--delete-older-than 5";  # Keep the latest 5 generations
  };


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
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

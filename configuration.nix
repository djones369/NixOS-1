# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

in 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      # For wayland support see the following config
      # ./qtile.nix
    ];

   home-manager.useUserPackages = true;
   home-manager.useGlobalPkgs = true;
   home-manager.backupFileExtension = "backup";
   home-manager.users.dave = import ./home.nix;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #--- Updated Kernel ---#
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Nix-Caddy"; # Define your hostname.
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

  # Enable Cosmic Desktop environment 
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.cosmic.enable = true;

  # Enable the qtile window manager (optional; LightDM lets you pick it at login)
  services.xserver.windowManager.qtile.enable = true;
  services.xserver.windowManager.qtile.extraPackages = p: with p; [ qtile-extras ];

  
  # NEW: autostart a polkit agent in your session (needed for virt-manager auth)
  services.xserver.displayManager.sessionCommands = ''
    if command -v /run/current-system/sw/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null; then
      /run/current-system/sw/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    fi
  '';

    # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # Enable CUPS to print documents & Avahi to allow other devices on the network to discover
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable Epson & HP Scanning
  services.udev.packages = [ pkgs.utsushi ];
  
  hardware.sane = {
    enable = true;  # enables support for SANE scanners
    extraBackends = [
      pkgs.epkowa          # Epson ES-400 backend
      pkgs.hplipWithPlugin # HP scanners (requires proprietary plugin)
    ];
  };

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
    extraGroups = [ "networkmanager" "wheel" "adbusers" "libvirtd" "video" "kvm" "render" "scanner" "lp" "audio" ];
    packages = with pkgs; [
    thunderbird
    rustdesk-flutter
    rustdesk-server
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Local Wordpress & Drupal
  #--- Wordpress---#  
  services.wordpress.sites."localhost" = {};


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



  # --- Enable Flatpak  ---
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # --- Flatpak auto-update ---#
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

# --- Virt-manager and libvirt ---#
virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    # ovmf.enable = true; # Don't need in Unstable
    swtpm.enable = true;
  };
};

# Enables the setuid ACL helper needed for USB redirection
virtualisation.spiceUSBRedirection.enable = true;

# Polkit for virt-manager actions without root prompts
security.polkit.enable = true;

# Nice-to-have: ships desktop integration polkit rules for virt-manager
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

  ];

# --- Weekly Garbage CLeaner --- #

  # If you use systemd-boot:
  boot.loader.systemd-boot.configurationLimit = 5;

  # Automatic garbage collection (adjust schedule/retention as you like)
  nix.gc = {
    automatic = true;
    dates = "weekly";                 # or "monthly", "daily", "Sat 03:00", etc.
    options = "--delete-older-than 10d";
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
  services.gvfs.enable = true;
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}


{ config, pkgs, lib, ... }:

# Home Manager configuration
# ------------------------------------------------------------
# Style guide:
# 1) Top-level identity & state
# 2) Imports (optional: split into modules later)
# 3) XDG & session environment
# 4) Shells & prompt
# 5) Programs / CLI tools
# 6) GUI apps
# 7) Services (HM-managed)
# 8) Files & dotfiles
# 9) Home packages
# ------------------------------------------------------------
{
  ########################################
  # 1) Identity & state
  ########################################
  home.username = "dave";
  home.homeDirectory = "/home/dave";
  # Pin to the HM version you first used; bump only when you accept option changes.
  home.stateVersion = "25.05";

  ########################################
  # 2) Optional module split (uncomment once you create files)
  ########################################
  # imports = [
  #   ./modules/shell.nix
  #   ./modules/dev.nix
  #   ./modules/apps.nix
  #   ./modules/services.nix
  # ];

  ########################################
  # 3) XDG & session
  ########################################
  xdg.enable = true;
  # Add directories to PATH ahead of others
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/bin" ];

  # Common environment variables
  home.sessionVariables = {
    EDITOR = "nano"; # change to "nvim" or "vim" if you prefer
    PAGER = "less";
    # LESS = "-R"; # keep colors
    # BROWSER = "firefox";
    # TERMINAL = "foot";
    # LANG = "en_US.UTF-8"; # typically set system-wide; uncomment if you need per-user override
  };

  ########################################
  # 4) Shells & prompt
  ########################################
  programs.bash = {
    enable = true;
    # Initialize prompt and extras here instead of editing ~/.bashrc
    # promptInit = ''
      # Bright magenta username, path, and $/#, then reset
      # PS1='\[\e[95m\]\u\[\e[0m\] \[\e[95m\]in\[\e[0m\] \[\e[95m\]\w\[\e[0m\] \[\e[95m\]\\$\[\e[0m\] '
    # '';
    shellAliases = {
      test = "sudo nixos-rebuild test";
      switch = "sudo nixos-rebuild switch";
      upgrade = "sudo nixos-rebuild switch --upgrade";
      btw = "echo I use NixOS btw";
      cls = "clear && fastfetch -c paleofetch";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      grep = "grep --color=auto";
    };
    historyControl = [ "ignoredups" "ignorespace" ];
    enableCompletion = true;
  bashrcExtra = ''
    # Run fastfetch with the paleofetch config at terminal start
    if command -v fastfetch >/dev/null 2>&1; then
      fastfetch -c paleofetch
    fi
  '';
};


  # Optional: a modern prompt
  # programs.starship = {
    # enable = true; # set to true if you want starship
    # settings = {
      # add_newline = true;
      # character = { success_symbol = "➜ "; error_symbol = "✗ "; };
    # };
  # };

  ########################################
  # 5) Programs (CLI)
  ########################################
  programs.git.settings = {
    enable = true;
    userName = "whamadmin";
    userEmail = "dave@westhasmptonlibrary.org"; # <- change to your real address
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.ssh.enableDefaultConfig = {
    enable = false;
    # matchBlocks."github.com" = { user = "git"; }; # example
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.htop.enable = true;


  ##### Neovim #####
    programs.neovim = {
      enable = true;
      # extraConfig = "set number relativenumber"; # Example: add basic VimL config
      # extraLuaConfig = "vim.opt.relativenumber = true"; # Example: add basic Lua config
      plugins = with pkgs.vimPlugins; [ # Example: manage plugins
        telescope-nvim
        nvim-treesitter.withAllGrammars
        nvim-cmp
        gruvbox-material
        nvim-lspconfig
        vim-commentary
      ];
    };




  ########################################
  # 6) GUI applications
  ########################################
  # HM can also manage desktop files & mime; enable xdg above
  programs.firefox.enable = false; # set true if you want HM to manage Firefox
  # programs.vscode.enable = true;  # enable if you prefer the OSS build; for MS build use pkgs.vscode

  ########################################
  # 7) User services
  ########################################
  # services.gpg-agent.enable = true;
  # services.gpg-agent.defaultCacheTtl = 1800;
  # services.gpg-agent.enableSshSupport = true;

  ########################################
  # 8) Files managed by HM
  ########################################
  # home.file.".config/myapp/config.toml".text = ''
  #   # Your app configuration here
  # '';

  ########################################
  # 9) Packages
  ########################################
  home.packages = with pkgs; [
  ##### System Tools #####
    htop  # interactive process viewer
    fastfetch # fast system information tool
    wget # network downloader
    unzip # archive extractor
    zip # archive creator
    pciutils # PCI device utilities
    nmap # Network mapper
    distrobox # Container management tool
    appimage-run # Run AppImage packages
    xdotool # Simulate keyboard input and mouse activity
    menulibre # Menu editor for desktop environments
    rofi # Window switcher, application launcher, and dmenu replacement
    flameshot # Screenshot tool
    gnome-software # GNOME software center
    gnome-disk-utility # Disk management utility
    epsonscan2

  ##### Security, Networking & Web Browsers#####
    gnupg # GPG for encryption & signing
    cifs-utils # Utilities for mounting and managing CIFS/SMB shares
    samba # SMB/CIFS file, print, and login server
    tor # The Onion Router for anonymous communication
    tor-browser # Web browser for accessing the Tor network
    google-chrome # Google Chrome web browser
    # brave # Brave web browser
    element-desktop # Element desktop client for Matrix
    discord # Discord chat client
    signal-desktop # Signal desktop client
    telegram-desktop # Telegram desktop client
    thunderbird # email client
    filezilla # FTP client
    remmina # remote desktop client
    

  ##### Audio & Multimedia #####
    vlc # Multimedia player
    mpv # Media player
    yt-dlp # YouTube downloader
    carla # Audio plugin host
    pwvucontrol # PipeWire volume control
    pipecontrol # PipeWire control tool
    wireplumber # PipeWire session manager
    pavucontrol # PulseAudio volume control
    ncpamixer # Ncurses PulseAudio mixer
    easyeffects # Audio effects processor
    ffmpeg-full # Multimedia framework
    audacity # Audio editor
    mumble # Low-latency voice chat
    obs-studio # Open Broadcaster Software for streaming and recording
    

  ##### Graphics & Design #####
    gimp3-with-plugins # GNU Image Manipulation Program
    imagemagick # Image processing tools

  ##### Editors, Terminals & Notes #####
    # vim # Vi IMproved, a programmer's text editor
    # vimPlugins.LazyVim # Lazy loading plugin manager for Vim
    geany # Lightweight IDE
    vscode # Visual Studio Code
    zed-editor # Zed text editor
    obsidian # Obsidian note-taking app
    ghostty # Ghost terminal emulator
    mate.mate-terminal # MATE terminal emulator
    alacritty # Alacritty terminal emulator
    kitty # Kitty terminal emulator

  ##### Development Tools #####
    git # Distributed version control system
    gh # GitHub CLI tool
    gitui # Terminal UI for Git
    gnumake # GNU make utility
    cmake # Cross-platform build system
    gcc # GNU Compiler Collection
    # clang
    go # Go programming language
    ispell # Interactive spell checker
    nil          # Nix language server
    shellcheck # Shell script analysis tool
    starship # Cross-shell prompt
    boxbuddy # Boxbuddy CLI tool
    github-desktop # GitHub Desktop client
    lmstudio # LM Studio IDE

  ##### Static Site & Docs #####
    pandoc # Document converter
    texlive.combined.scheme-small # TeX Live LaTeX distribution
    aspell # Spell checker
    marp-cli # Markdown presentation tool
    hexo-cli # Static site generator
    hugo # Static site generator
    jekyll # Static site generator
    ghost-cli # Ghost blog CLI tool

  ##### Virtualization #####
    virt-manager # Virtual machine manager
    virt-viewer # Virtual machine viewer
    usbredir # USB redirection tool
    qemu # QEMU emulator
    qemu_kvm # QEMU KVM accelerator
    libvirt # Virtualization API
    swtpm # Software TPM emulator
    spice-protocol # SPICE protocol definitions
    spice-gtk # SPICE GTK client
    polkit_gnome # GNOME Polkit authentication agent  

  ##### Password Manager #####
    bitwarden-desktop # Bitwarden desktop client

  ##### Fonts #####
    nerd-fonts.symbols-only # Nerd Fonts Symbols Only
    nerd-fonts.fira-code # Fira Code Nerd Font
    nerd-fonts.fira-mono # Fira Mono Nerd Font
    nerd-fonts.roboto-mono # Roboto Mono Nerd Font
    nerd-fonts.hack # Hack Nerd Font
    nerd-fonts.inconsolata # Inconsolata Nerd Font
    nerd-fonts.jetbrains-mono # JetBrains Mono Nerd Font

  ##### Neovim Packages #####
    fd
    ripgrep
    
  
  
  ##### Qtile #####
    lxappearance
    picom
    networkmanagerapplet
    nitrogen

  ];  # <-- close the list AND add a semicolon

  ########################################
  # Neovim configuration (optional)
  ########################################

  # If you want HM to manage Neovim, uncomment:
  # programs.neovim.enable = true;
}  # <-- this is the ONE final brace that closes the top-level set

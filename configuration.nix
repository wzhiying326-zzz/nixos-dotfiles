{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "wzy-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-fluent
        fcitx5-mellow-themes
        catppuccin-fcitx5
        (fcitx5-rime.override {
          rimeDataPkgs = [
            rime-ice
            rime-moegirl
            rime-zhwiki
          ];
        })
      ];
      settings = {
        inputMethod = {
          "GroupOrder"."0" = "default";
          "Groups/0" = {
            Name = "default";
            DefaultIM = "rime";
            "Default Layout" = "us";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "rime";
            Layout = "us";
          };
        };
        globalOptions = {
        };
        addons = {
          classicui.globalSection = {
            Theme = "Catppuccin-Frappe-Pink";
            VerticalCandidateList = true;
          };
          clipboard.globalSection = {
            TriggerKey = "";
          };
          notifications.globalSection = { };
          notifications.sections.HiddenNotifications."0" = "fcitx-rime-deploy";
        };
      };
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.wzy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  # niri
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  services.displayManager.ly.enable = true;

  # gnome
  services.gvfs.enable = true;
  security.polkit.enable = true;
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    tree-sitter
    wget
    git
    kitty
    fastfetch
    yazi
    nautilus
    nautilus-open-any-terminal
    file-roller
    papirus-icon-theme
    libnotify
  ];

  environment.variables.EDITOR = "nvim";

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    maple-mono.NF-CN
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";
}

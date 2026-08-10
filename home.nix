{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    fuzzel = "fuzzel";
    niri = "niri";
    kitty = "kitty";
    fish = "fish";
    waybar = "waybar";
    wleave = "wleave";
    mako = "mako";
    swaylock = "swaylock";
    swayidle = "swayidle";
    starship = "starship";
  };
in

{
  imports = [
    ./home/fcitx5.nix
  ];
  home.username = "wzy";
  home.homeDirectory = "/home/wzy";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "wzy";
        email = "zhiying326@outlook.com";
      };
    };
  };
  programs.chromium = {
    enable = true;
    extensions = [
      "bgnkhhnnamicmpeenaelnjfhikgbkllg"
    ];
  };
  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      name = "Papirus-Dark";
    };
  };
  xdg.terminal-exec = {
    enable = true;
    settings = {
      # 设置默认终端为 kitty
      default = [ "kitty.desktop" ];
    };
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    nixd
    nixfmt
    rustc
    cargo
    nodejs
    gcc
    fuzzel
    fish
    waybar
    awww
    wleave
    mako
    swaylock-effects
    swayidle
    mpv
    wl-clipboard
    cliphist
    starship
  ];

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}

{ pkgs, config, ... }:
{
  # 放置 Rime 用户配置文件
  xdg.dataFile."fcitx5/rime/default.custom.yaml".source =
    let
      toYAML = (pkgs.formats.yaml { }).generate "default.custom.yaml";
    in
    toYAML {
      patch = {
        __include = "rime_ice_suggestion:/";
      };
    };
}

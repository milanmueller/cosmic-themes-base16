{ config, pkgs, ... }:
{
  programs.cosmic-themes-base16 = {
    enable = true;
    theme = {
      mode = "dark";
      base00 = "#123456";
      base01 = "#123456";
      base02 = "#123456";
      base03 = "#123456";
      base04 = "#123456";
      base05 = "#123456";
      base06 = "#123456";
      base07 = "#123456";
      base08 = "#123456";
      base09 = "#123456";
      base0A = "#123456";
      base0B = "#123456";
      base0C = "#123456";
      base0D = "#123456";
      base0E = "#123456";
      base0F = "#123456";
    };
  };
  home.stateVersion = "24.05";
  home.username = "test";
  home.homeDirectory = "/home/test";
}

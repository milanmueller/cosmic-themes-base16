{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.cosmic-themes-base16;
in
{
  options.programs.cosmic-themes-base16 = {
    enable = lib.mkEnableOption "Enable cosmic-themes-base16";
    theme = lib.mkOption {
      type = lib.types.submodule {
        options = {
          mode = lib.mkOptions {
            type = lib.types.enum [
              "light"
              "dark"
            ];
            default = "dark";
            description = ''
              Set the mode of the base16 theme.
              Possible values are "light" and "dark".
            '';
          };
          base00 = lib.mkOption { type = lib.types.str; };
          base01 = lib.mkOption { type = lib.types.str; };
          base02 = lib.mkOption { type = lib.types.str; };
          base03 = lib.mkOption { type = lib.types.str; };
          base04 = lib.mkOption { type = lib.types.str; };
          base05 = lib.mkOption { type = lib.types.str; };
          base06 = lib.mkOption { type = lib.types.str; };
          base07 = lib.mkOption { type = lib.types.str; };
          base08 = lib.mkOption { type = lib.types.str; };
          base09 = lib.mkOption { type = lib.types.str; };
          base0A = lib.mkOption { type = lib.types.str; };
          base0B = lib.mkOption { type = lib.types.str; };
          base0C = lib.mkOption { type = lib.types.str; };
          base0D = lib.mkOption { type = lib.types.str; };
          base0E = lib.mkOption { type = lib.types.str; };
          base0F = lib.mkOption { type = lib.types.str; };
        };
      };
      description = ''
        The base16 theme to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.cosmic-themes-base16 ];

    home.activation.generateCosmicTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.cosmic-themes-base16}/bin/cosmic-themes-base16 \
        -- mode ${cfg.theme.mode} \
        -- base00 ${cfg.theme.base00} \
        -- base01 ${cfg.theme.base00} \
        -- base02 ${cfg.theme.base00} \
        -- base03 ${cfg.theme.base00} \
        -- base04 ${cfg.theme.base00} \
        -- base05 ${cfg.theme.base00} \
        -- base06 ${cfg.theme.base00} \
        -- base07 ${cfg.theme.base00} \
        -- base08 ${cfg.theme.base00} \
        -- base09 ${cfg.theme.base00} \
        -- base0a ${cfg.theme.base00} \
        -- base0b ${cfg.theme.base00} \
        -- base0c ${cfg.theme.base00} \
        -- base0d ${cfg.theme.base00} \
        -- base0e ${cfg.theme.base00} \
        -- base0f ${cfg.theme.base00} \
    '';
  };
}

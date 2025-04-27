{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cosmic-themes-base16;

  # Helper function to convert hex colors to the format expected by cosmic-themes-base16
  formatTheme =
    theme:
    let
      # Ensure we always have a light/dark mode set
      mode = if theme.mode != null then theme.mode else "dark";

      # Check if we're using a YAML file or direct color values
      command =
        if theme.yamlFile != null then
          "${pkgs.cosmic-themes-base16}/bin/cosmic-themes-base16 ${mode} ${theme.yamlFile}"
        else
          "${pkgs.cosmic-themes-base16}/bin/cosmic-themes-base16 ${mode} ${
            concatStringsSep " " [
              theme.base00
              theme.base01
              theme.base02
              theme.base03
              theme.base04
              theme.base05
              theme.base06
              theme.base07
              theme.base08
              theme.base09
              theme.base0A
              theme.base0B
              theme.base0C
              theme.base0D
              theme.base0E
              theme.base0F
            ]
          }";
    in
    {
      inherit command;
      inherit mode;
    };

  # Type for a single theme definition
  themeType = types.submodule {
    options = {
      mode = mkOption {
        type = types.enum [
          "light"
          "dark"
        ];
        default = "dark";
        description = "Whether the theme is light or dark.";
      };

      yamlFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a Base16 YAML theme file.";
      };

      # Base16 color options
      base00 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Background color.";
      };

      base01 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Lighter background color.";
      };

      base02 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Selection background color.";
      };

      base03 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Comments, invisibles color.";
      };

      base04 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Dark foreground color.";
      };

      base05 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Default foreground color.";
      };

      base06 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Light foreground color.";
      };

      base07 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Light background color.";
      };

      base08 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Red color.";
      };

      base09 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Orange color.";
      };

      base0A = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Yellow color.";
      };

      base0B = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Green color.";
      };

      base0C = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Cyan color.";
      };

      base0D = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Blue color.";
      };

      base0E = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Purple color.";
      };

      base0F = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Brown color.";
      };
    };
  };
in
{
  options.programs.cosmic-themes-base16 = {
    enable = mkEnableOption "cosmic-themes-base16";

    package = mkOption {
      type = types.package;
      default = pkgs.cosmic-themes-base16;
      description = "The cosmic-themes-base16 package to use.";
    };

    theme = mkOption {
      type = themeType;
      default = { };
      description = "Base16 theme configuration to use for COSMIC desktop.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Generate the theme files and place them in the proper config directories
    home.activation.generateCosmicTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $HOME/.config/cosmic/theme/builder
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $HOME/.config/cosmic/theme/theme

      # Validate inputs
      if [[ -z "${if cfg.theme.yamlFile != null then cfg.theme.yamlFile else ""}" ]]; then
        # Check that all colors are provided when not using YAML
        ${concatMapStringsSep "\n"
          (color: ''
            if [[ -z "${cfg.theme.${color} or ""}" ]]; then
              echo "Error: Missing required color ${color} in programs.cosmic-themes-base16.theme"
              exit 1
            fi
          '')
          [
            "base00"
            "base01"
            "base02"
            "base03"
            "base04"
            "base05"
            "base06"
            "base07"
            "base08"
            "base09"
            "base0A"
            "base0B"
            "base0C"
            "base0D"
            "base0E"
            "base0F"
          ]
        }
      fi

      # Run the theme generator
      ${
        let
          theme = formatTheme cfg.theme;
        in
        ''
          $DRY_RUN_CMD ${theme.command}

          # Copy the generated theme files to the COSMIC config directory
          $DRY_RUN_CMD cp -r $VERBOSE_ARG output/builder/* $HOME/.config/cosmic/theme/builder/
          $DRY_RUN_CMD cp -r $VERBOSE_ARG output/theme/* $HOME/.config/cosmic/theme/theme/
        ''
      }
    '';
  };
}

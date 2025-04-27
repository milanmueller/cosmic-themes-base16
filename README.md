# cosmic-themes-base16

Generate COSMIC desktop themes from Base16 color schemes.

## Overview

This tool takes Base16 color schemes and converts them to COSMIC desktop themes. It supports both direct color hex values and Base16 YAML files.

## NixOS Home Manager Module

This repository includes a Home Manager module for NixOS users to easily generate and apply COSMIC themes.

### Using as a Flake

You can import this repository as a flake in your Home Manager or NixOS configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cosmic-themes-base16.url = "github:yourusername/cosmic-themes-base16";
  };

  outputs = { self, nixpkgs, home-manager, cosmic-themes-base16, ... }: {
    # Configuration using the module
    homeConfigurations."username" = home-manager.lib.homeManagerConfiguration {
      # ...
      modules = [
        cosmic-themes-base16.homeManagerModules.default
        # or cosmic-themes-base16.homeManagerModules.cosmic-themes-base16
        
        # Your configuration
        {
          programs.cosmic-themes-base16 = {
            enable = true;
            theme = {
              mode = "dark"; # or "light"
              
              # Option 1: Provide a YAML file
              yamlFile = /path/to/base16/theme.yaml;
              
              # Option 2: Provide all colors directly
              # base00 = "#181818"; # Background
              # base01 = "#282828"; # Lighter background
              # base02 = "#383838"; # Selection background
              # base03 = "#585858"; # Comments, invisibles
              # base04 = "#b8b8b8"; # Dark foreground
              # base05 = "#d8d8d8"; # Default foreground
              # base06 = "#e8e8e8"; # Light foreground
              # base07 = "#f8f8f8"; # Light background
              # base08 = "#ab4642"; # Red
              # base09 = "#dc9656"; # Orange
              # base0A = "#f7ca88"; # Yellow
              # base0B = "#a1b56c"; # Green
              # base0C = "#86c1b9"; # Cyan
              # base0D = "#7cafc2"; # Blue
              # base0E = "#ba8baf"; # Purple
              # base0F = "#a16946"; # Brown
            };
          };
        }
      ];
    };
  };
}
```

### Traditional Module Import

Alternatively, you can import the module directly in your `home.nix`:

```nix
{ pkgs, ... }:

let
  cosmic-themes-base16 = import /path/to/cosmic-themes-base16 { inherit pkgs; };
in {
  imports = [
    (cosmic-themes-base16.hmModule { 
      inherit pkgs; 
      inherit (pkgs) lib; 
    })
  ];

  programs.cosmic-themes-base16 = {
    enable = true;
    theme = {
      mode = "dark"; # or "light"
      
      # Option 1: Provide a YAML file
      yamlFile = /path/to/base16/theme.yaml;
      
      # Option 2: Provide all colors directly as shown in the example below
    };
  };
}
```

### Example with Gruvbox Dark Theme

```nix
programs.cosmic-themes-base16 = {
  enable = true;
  theme = {
    mode = "dark";
    base00 = "#282828"; # bg
    base01 = "#3c3836"; # bg1
    base02 = "#504945"; # bg2
    base03 = "#665c54"; # bg3
    base04 = "#bdae93"; # fg2
    base05 = "#d5c4a1"; # fg1
    base06 = "#ebdbb2"; # fg0
    base07 = "#fbf1c7"; # fg0
    base08 = "#fb4934"; # red
    base09 = "#fe8019"; # orange
    base0A = "#fabd2f"; # yellow
    base0B = "#b8bb26"; # green
    base0C = "#8ec07c"; # aqua
    base0D = "#83a598"; # blue
    base0E = "#d3869b"; # purple
    base0F = "#d65d0e"; # orange
  };
}
```

## Manual CLI Usage

```bash
# Using direct color values
cosmic-themes-base16 dark|light "#base00" "#base01" ... "#base0f"

# Using a YAML file
cosmic-themes-base16 dark|light path/to/base16/theme.yaml
```

The program will generate theme files in the `output/` directory which can be copied to `~/.config/cosmic/theme/`.
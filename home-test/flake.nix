{
  description = "Minimal Home Manager test for cosmic-themes-base16";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cosmic-themes-base16 = {
      url = "path:/home/milan/git/cosmic-themes-base16"; # Pfad anpassen, falls nötig
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      cosmic-themes-base16,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.milan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          cosmic-themes-base16.homeManagerModules.default
          {
            home.username = "milan";
            home.homeDirectory = "/home/milan";
            home.stateVersion = "23.11";

            programs.cosmic-themes-base16 = {
              enable = true;
              theme = {
                mode = "dark";
                base00 = "#1d2021";
                base01 = "#3c3836";
                base02 = "#504945";
                base03 = "#665c54";
                base04 = "#bdae93";
                base05 = "#d5c4a1";
                base06 = "#ebdbb2";
                base07 = "#fbf1c7";
                base08 = "#fb4934";
                base09 = "#fe8019";
                base0A = "#fabd2f";
                base0B = "#b8bb26";
                base0C = "#8ec07c";
                base0D = "#83a598";
                base0E = "#d3869b";
                base0F = "#d65d0e";
              };
            };
          }
        ];
      };
    };
}

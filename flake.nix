{
  description = "Generate COSMIC Theme configuration files from base16 color schemes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    let
      appName = "cosmic-themes-base16";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
        };

        appPackage = pkgs.rustPlatform.buildRustPackage {
          pname = appName;
          version = "0.1.0";
          src = self;
          useFetchCargoVendor = true;
          cargoLock = {
            lockFile = ./Cargo.lock;
            allowBuiltinFetchGit = true;
          };
          nativeBuildInputs = [ rustToolchain ];
        };
      in
      {
        packages = {
          default = appPackage;
          ${appName} = appPackage;
        };

        overlays.default = final: prev: {
          ${appName} = appPackage;
        };
      }
    )
    // {
      homeManagerModules.default = import ./home-manager-module.nix;
    };
}

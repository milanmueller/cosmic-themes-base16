{
  description = "cosmic-themes-base16: Generate COSMIC theme configuration files from a base16 scheme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    # Add home-manager as an input
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      home-manager,
    }:
    let
      # Home Manager module that can be imported
      homeManagerModule = { config, lib, pkgs, ... }:
        let
          module = import ./module.nix {
            inherit config lib pkgs;
          };
        in
        module;
    in
    {
      # Expose the homeManagerModule
      homeManagerModules.default = homeManagerModule;
      homeManagerModules.cosmic-themes-base16 = homeManagerModule;
    } // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        # Rust toolchain (used for both building and dev shell)
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ]; # For IDE support
        };

        # Build cosmic-themes-base16
        cosmicThemesBase16 = pkgs.rustPlatform.buildRustPackage {
          pname = "cosmic-themes-base16";
          version = "0.1.0";
          src = self; # Use the flake's root directory
          useFetchCargoVendor = true;
          cargoLock = {
            lockFile = ./Cargo.lock;
            allowBuiltinFetchGit = true; # Evil hack, but below attempt does not work for submodules somehow...
          };
          nativeBuildInputs = [ rustToolchain ];
        };
      in
      {
        # Packages
        packages.default = cosmicThemesBase16;
        packages.cosmic-themes-base16 = cosmicThemesBase16;

        # Development shell
        devShells.default = pkgs.mkShell {
          # Include the Rust toolchain and additional tools
          packages = with pkgs; [
            rustToolchain
            cargo-watch # From the template
            # Add more tools if you like
            cargo-edit
            rustfmt
            clippy
            nix-prefetch-git # Needed for finding sha256 hashes
          ];
          # Optional: Set environment variables
          shellHook = ''
            echo "Rust development environment loaded"
            echo "Rust version: $(rustc --version)"
          '';
        };
      }
    ));
}

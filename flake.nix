{
  description = "cosmic-themes-base16: Generate COSMIC theme configuration files from a base16 scheme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    # Optional: Explicitly fetch Git dependencies as inputs
    # iced = {
    #   url = "github:iced-rs/iced";
    #   flake = false; # Not a flake, just a Git repo
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    # iced,
    }:
    flake-utils.lib.eachDefaultSystem (
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
        # Vendor dependencies
        # vendorDir = pkgs.rustPlatform.fetchCargoTarball {
        #   src = self;
        #   lockFile = ./Cargo.lock;
        #   outputHashes = {
        #     "cosmic-config-0.1.0" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
        #     "cosmic-config-derive-0.1.0" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
        #     "cosmic-theme-0.1.0" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
        #     "atomicwrites-0.4.2" = "0447an9qrbvad8ig4ndzpb2519m22yh5m1f7pjn1ypn9z8cax521";
        #     "clipboard_macos-0.1.0" = "1xm197cr1gya0vxi2vly4jpkjhfdcjmviv8hkih5y6pm2yc8dh7v";
        #     "smithay-clipboard-0.8.0" = "0zmzxl0cjd0pz1qrcr2akhx9wz0k5si7ljykms2vm1hsdmgcb2g0";
        #   };
        # };
        # Build cosmic-themes-base16
        # cosmicThemesBase16 = pkgs.stdenv.mkDerivation {
        #   pname = "cosmic-themes-base16";
        #   version = "0.1.0";
        #   src = self;

        #   nativeBuildInputs = with pkgs; [
        #     rustToolchain
        #     git
        #   ];
        #   # Configure cargo to use vendored dependencies
        #   configurePhase = ''
        #     mkdir -p .cargo
        #     cat > .cargo/config.toml <<EOF
        #     [source.creates-io]
        #     replace-with = "vendored-sources"

        #     [source.vendored-sources]
        #     directory = "${vendorDir}"
        #     EOF
        #   '';

        #   buildPhase = ''
        #     # Build project with cargo
        #     cargo build --release --locked --offline
        #   '';

        #   installPhase = ''
        #     mkdir -p $out/bin
        #     cp target/release/cosmic-themes-base16 $out/bin
        #   '';
        # };

        # Build cosmic-themes-base16
        cosmicThemesBase16 = pkgs.rustPlatform.buildRustPackage {
          pname = "cosmic-themes-base16";
          version = "0.1.0";
          src = self; # Use the flake's root directory
          useFetchCargoVendor = true;
          cargoLock = {
            lockFile = ./Cargo.lock;
            allowBuiltinFetchGit = true; # Evil hack, but below attempt does not work for submodules somehow...
            # outputHashes = {
            #   "cosmic-config-0.1.0" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
            #   "cosmic-config-derive-0.1.0" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
            #   # "iced-0.14.0-dev" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
            #   "cosmic-theme-0.1.0" = "06gr67frb2jq4pnkxmmwz8zgp3a2wb29acx8ch3yzd7hr7lsgjmd";
            #   "atomicwrites-0.4.2" = "0447an9qrbvad8ig4ndzpb2519m22yh5m1f7pjn1ypn9z8cax521";
            #   "clipboard_macos-0.1.0" = "1xm197cr1gya0vxi2vly4jpkjhfdcjmviv8hkih5y6pm2yc8dh7v";
            #   # "cosmic-text-0.13.2" = "1lf61x00r5j9c64857didlpa3aacz30mrbymhcrjafmvq5mr3dy0";
            #   "smithay-clipboard-0.8.0" = "0zmzxl0cjd0pz1qrcr2akhx9wz0k5si7ljykms2vm1hsdmgcb2g0";
            #   # "softbuffer-0.4.1" = "06ly5rl9p0vp5jdlahij5aqxqhvqvwbhgarjx3k1j4j0dyjfbivp";
            # };
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
    );
}

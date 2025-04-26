{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}:

{
  # The home-manager module
  hmModule = import ./module.nix;
  
  # The package itself
  cosmic-themes-base16 = pkgs.rustPlatform.buildRustPackage {
    pname = "cosmic-themes-base16";
    version = "0.1.0";
    
    src = ./.;
    
    cargoLock = {
      lockFile = ./Cargo.lock;
    };
    
    meta = with lib; {
      description = "Generate COSMIC desktop themes from Base16 color schemes";
      homepage = "https://github.com/yourusername/cosmic-themes-base16";
      license = licenses.mit;
      maintainers = [];
    };
  };
}
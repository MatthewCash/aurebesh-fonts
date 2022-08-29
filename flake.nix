{
    description = "Aurebesh Fonts";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";

        flake-utils = {
            url = "github:numtide/flake-utils";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        
        aurabesh = {
            url = "https://aurekfonts.github.io/Aurabesh/AURABESH.ttf";
            flake = false;
        };
    };

    outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in rec {
            defaultPackage = pkgs.stdenvNoCC.mkDerivation {
                name = "aurebesh-font";
                src = inputs.aurabesh;
                dontUnpack = true;
                dontConfigure = true;
                installPhase = ''
                    cp $src aurebesh.ttf
                    local out_ttf=$out/share/fonts/truetype
                    install -m444 -Dt $out_ttf aurebesh.ttf
                '';
            };
        }
    );
}

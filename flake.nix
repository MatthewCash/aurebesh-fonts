{
    description = "Aurebesh Fonts";

    inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

    outputs = { nixpkgs, ... }:
    let
        forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
        packageFor = system:
            let pkgs = nixpkgs.legacyPackages.${system}; in
            pkgs.stdenvNoCC.mkDerivation {
                name = "aurebesh-font";
                src = builtins.path {
                    path = ./.;
                    name = "aurebesh-fonts-source";
                };
                nativeBuildInputs = [ pkgs.fontforge ];
                dontConfigure = true;
                installPhase = ''
                    local out_ttf=$out/share/fonts/opentype
                    mkdir -p $out_ttf
                    fontforge -script scripts/mirror-capitals.py
                    install -m 0644 aurebesh.otf $out_ttf/aurebesh.otf
                '';
            };
    in {
        packages = forAllSystems (system: {
            default = packageFor system;
        });
        defaultPackage = forAllSystems packageFor;
    };
}

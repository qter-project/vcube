{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        deps = with pkgs; [
            clang
            cmake
            pkg-config
            cpputest
          ];
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = deps;
        };

        packages.vcube = pkgs.stdenv.mkDerivation {
          name = "vcube";
          src = ./.;
          buildInputs = deps;
          buildPhase = ''
            cmake .
            make -j
          '';
          checkPhase = ''
            ./tests/check
          '';
          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/lib
            cp vc-optimal $out/bin
            cp gen-const-cubes $out/bin
            cp libvcube.a $out/lib
          '';
        };

        defaultPackage = packages.vcube;
        legacyPackages = packages;
      }
    );
}

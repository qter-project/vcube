let
  pkgs = import <nixpkgs> { };
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    clang
    cmake
    pkg-config
    cpputest
  ];
}

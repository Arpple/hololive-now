{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    buildPackages.elixir_1_10
    buildPackages.erlangR22
    buildPackages.nodejs-12_x
  ];
}

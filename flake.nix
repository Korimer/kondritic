{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ ... }: {
    with-kontext = (import ./kondritic.nix);
  };
}

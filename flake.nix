{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ ... }: (import ./kondritic.nix { inherit inputs; });
}

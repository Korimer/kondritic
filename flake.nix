{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    kondritic.url = "github:Korimer/Kondritic";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ ... }: {
    nixosConfigurations.fortnite = inputs.nixpkgs.nixosSystem {
      modules = [];
    };
  };
}

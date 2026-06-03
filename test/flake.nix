{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    kondritic.url = "git+file:../";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ ... }: {
    nixosConfigurations.fortnite = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ({ ... }: inputs.kondritic.with-kontext inputs (import ./configuration.nix) (import ./konfig.nix) )
      ];
    };
  };
}


{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    kondritic.url = "github:Korimer/kondritic";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ ... }: {
    nixosConfigurations.fortnite = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ({ ... }: { inputs.nixpkgs.hostPlatform = "x86_64linux"; } )
        ./configuration.nix
      ];
    };
  };
}


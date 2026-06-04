{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    kondritic.url = "github:Korimer/kondritic";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ ... }: 
    inputs.kondritic.with-kontext
      inputs
      (import ./configuration.nix)
      (import ./konfig.nix)
  ;

}


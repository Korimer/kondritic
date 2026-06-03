let
  options = {
    #nixos = (builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options;
    #home = (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.<name>.options.home-manager.users.type.getSubOptions []    };
  };

  nixosfinal = { inputs, ... }: inputs.nixpkgs.lib.nixosSystem options.nixos;

  homefinal = {};
  optionsfinal = {
    den._internal.options = {
      nixos = nixosfinal.options;
      home = nixosfinal.options.home-manager.users.type.getSubOptions [];
    };
  };

  kon-out = 
    nixosfinal
    // homefinal
    // optionsfinal
  ;
in

args: module: config:
  args.nixpkgs.lib.mapAttrs'
    (key: val: {name = key; value = val;})
    (module {})

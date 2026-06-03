let 
  mkHost = nixpkgs: hostname: options: {${hostname} = (nixpkgs.lib.nixosSystem options); };
in

args: module: config:
  let
    hosts = config.hosts;

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

    lol = args.nixpkgs.lib.mapAttrs'
      (key: val: {name = key; value = val;})
      (module {})
    ;
  in
  args.nixpkgs.lib.listToAttrs
  map (name:
    {name = name; value = mkHost args.nixpkgs name lol;}
  )

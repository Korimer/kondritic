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

    lol = args.nixpkgs.lib.mapAttrs'
      (key: val: {name = key; value = val;})
      (module {})
    ;

    allNixConfigs = map
      (hostname:
        {name = hostname; value = mkHost args.nixpkgs hostname lol;}
      )
      hosts
    ;

    configsFinal = args.nixpkgs.lib.listToAttrs allNixConfigs;

    kon-out = configsFinal // lol;

  in kon-out


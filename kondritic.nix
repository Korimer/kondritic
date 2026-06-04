let 
  mkHost = nixpkgs: options:
    (nixpkgs.lib.nixosSystem
      { modules = [ options ]; }
    );
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

    nixConfigArr = map
      (hostname:
        {name = hostname; value = mkHost args.nixpkgs lol;}
      )
      hosts
    ;

    allNixConfigs = args.nixpkgs.listToAttrs nixConfigArr;
    
    allNixOptions = args.nixpkgs.lib.mapAttrs
      (key: val: val.options )
      allNixConfigs
    ;

    configsFinal = { nixosConfigurations = allNixConfigs; };

    kon-out = 
      configsFinal
      // { kon.options.nixos = allNixOptions; }
    ;

  in kon-out


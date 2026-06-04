let 
  # directory reading
  importDir = lib: directory: lib.flatten (
    lib.pipe directory [
      builtins.readDir
      (lib.filterAttrs (name: type: type == "directory" || lib.hasSuffix ".nix" name))
      (lib.filterAttrs (name: _: !(lib.hasPrefix "_" name)))
      (lib.mapAttrsToList (
        name: type: if type == "directory"
          then importDir (directory + ("/" + name))
          else directory + ("/" + name)
      ))
    ]
  );
in

inputs: module: config:
let
  konlib = {
    mkHost = options:
      (inputs.nixpkgs.lib.nixosSystem
        { modules = options; }
      );

    mkUser = options:
      (inputs.home-manager.lib.homeManagerConfiguration
        { modules = options; }
      );
  };

  hosts = config.hosts;
  users = config.users;

  options = {
    #nixos = (builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options;
    #home = (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.<name>.options.home-manager.users.type.getSubOptions []    };
    };

    lol = inputs.nixpkgs.lib.mapAttrs'
      (key: val: {name = key; value = val;})
      (module {})
    ;

    nixConfigArr = map
      (hostname:
        {name = hostname; value = konlib.mkHost inputs.nixpkgs [lol];}
      )
      hosts
    ;

    allNixConfigs = inputs.nixpkgs.lib.listToAttrs nixConfigArr;
    
    allNixOptions = inputs.nixpkgs.lib.mapAttrs
      (key: val: val.options )
      allNixConfigs
    ;

    configsFinal = { nixosConfigurations = allNixConfigs; };

    kon-out = 
      configsFinal
      // { kon.options.nixos = allNixOptions; }
    ;

  in kon-out


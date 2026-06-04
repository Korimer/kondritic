{ inputs }:
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

    pathToArr = escapedPath:
        inputs.nixpkgs.lib.splitString "/" escapedPath;

    arrToAttrs = arr:
      if ((builtins.length arr) == 0)
        then {}
        else { ${builtins.head arr} = konlib.arrToAttrs (builtins.tail arr); }
    ;

    pathToAttrs = path:
      let
        files = path': konlib.pathToArr (
          builtins.replaceStrings [ "." ] [ "_" ]
          (inputs.nixpkgs.lib.strings.removeSuffix ".nix" path)
        );
      in
      if (path == "")
        then {}
        else konlib.arrToAttrs (files path)
    ;
  };

  with-kontext = { config, module }:
  let

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

  in configsFinal;

  kon-out = {
    kon = {
      #options.nixos = with-kontext.allNixOptions;
      lib = konlib;
    };
    with-kontext = with-kontext;
  };

in kon-out

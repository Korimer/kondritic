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

    _pathToAttrs = escapedPath:
      let
        match = builtins.match "([^/]+)/(.*)" escapedPath;
      in
        if match == null then
          { ${escapedPath} = {}; }
        else
          {
            ${builtins.elemAt match 0} =
              konlib._pathToAttrs (builtins.elemAt match 1);
          }
      ;

    pathToAttrs = path:
      konlib._pathToAttrs (
        builtins.replaceStrings [ "." ] [ "_" ]
      (inputs.nixpkgs.lib.strings.removeSuffix ".nix" path)
      )
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

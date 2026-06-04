```nix
{
    nature = {
        # Whether to include this module when importing one of its parents.
        includeSelf = true;
        # Any external modules that this has as a dependency
        autoincludes = [];
        # Whether to include this module's childeren when importing it
        childeren = {
            # Whether only one child can be imported;
            mutex = false;
            # If mutex is true, which child to be imported when not otherwise specified.
            default = "";
        };
    };

    # Nixos options
    nixos = {};
    # Home-Manager options
    home = {};
```

Example structure:
```
.
├── flake.nix
├── flake.lock
├── konfig.nix
├── hosts
│   ├── igloo
│   │   ├── users.nix
│   │   └── groups.nix
│   └── snowglobe.nix
├── users
│   ├── tux
│   │   ├── nvim.nix
│   │   └── git.nix
│   └── xenia.nix
└── features
    ├── activedirectory.nix
    └── wallpaperlibrary
        ├── awww.nix
        └── _wallpapers
            ├── wallpaper1.png
            ├── wallpaper2.png
            └── wallpaper3.png
```

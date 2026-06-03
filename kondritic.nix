args: module:
  args.nixpkgs.lib.mapAttrs
  (val: val)
  (module args)

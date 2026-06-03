args: module:
  args.nixpkgs.lib.mapAttrs
  (key: val: val)
  module

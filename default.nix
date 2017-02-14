{ nixpkgs ? import ./nixpkgs {}, profiling ? false }:

with nixpkgs;

let
  inherit (pkgs.haskell) lib;
  haskellPackages = pkgs.haskellPackages.override {
    overrides = self: super: {

      mkDerivation = args: super.mkDerivation (args // {
        enableLibraryProfiling = profiling;
      });

      hnix = self.callPackage ./hnix/project.nix {};
    };
  };
  filterSource = drv: pred:
    lib.overrideCabal drv
    (args: args // { src = builtins.filterSource pred args.src; });
  omitDirs =
    let
      omitted = [ ".git" "dist" "nixpkgs" "hnix" ];
    in drv:
    filterSource drv
    (path: type:
      type != "directory" || !(stdenv.lib.elem (baseNameOf path) omitted));
in
omitDirs (haskellPackages.callPackage ./emacs2nix.nix {})

{
  description = "Research - Read more research";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        sources = pkgs.callPackage ./_sources/generated.nix { };
      in
      {
        packages = {
          unms-research = pkgs.callPackage ./package.nix { inherit sources; };
          default = self.packages.${system}.unms-research;
        };

        apps = {
          unms-research = flake-utils.lib.mkApp {
            drv = self.packages.${system}.unms-research;
          };
          default = self.apps.${system}.unms-research;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nvfetcher
          ];
        };
      }
    )
    // {
      overlays.default = final: prev: {
        unms-research = final.callPackage ./package.nix {
          sources = final.callPackage ./_sources/generated.nix { };
        };
      };
    };
}

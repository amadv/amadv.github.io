{
  description = "Nix flake for sprea.github.io";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; # also valid: "nixpkgs";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
      {
        packages = forAllSystems( {pkgs }:
          {
            "amadv.github.io" = (pkgs.callPackage ./amadv.github.io.nix {});
            feedback = (pkgs.callPackage ./feedback.nix {});
            default = (pkgs.callPackage ./amadv.com.nix {});
          }
        );
        overlays.default = final: prev: {
          amadvcom = (prev.callPackage ./amadv.github.io.nix {});
          feedback = (prev.callPackage ./feedback.nix {});
        };
      };
}

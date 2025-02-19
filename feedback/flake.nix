{
  description = "Feedback";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
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

      make_package = pkgs: pkgs.rustPlatform.buildRustPackage rec {
        pname = "feedback";
        name = pname;
        src = self;

        cargoHash = "sha256-Arxlxu1tSsXZmY1Pf65/MrsYqJLEI7If15XWbH3/9K8=";

        nativeBuildInputs = with pkgs; [
          openssl
          pkg-config
        ];

        buildInputs = with pkgs; [
          rustfmt
          clippy
          rust-analyzer
        ];

        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      };
    in
      {
        packages = forAllSystems({ pkgs }: rec {
          feedback = make_package pkgs;
          default = feedback;
        });
        overlays.default = final: prev: {
          feedback = make_package prev;
        };
      };
}

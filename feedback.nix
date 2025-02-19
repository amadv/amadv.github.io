{ pkgs, stdenv }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "feedback";
  name = pname;
  src = ./feedback;

  cargoHash = "sha256-Arxlxu1tSsXZmY1Pf65/MrsYqJLEI7If15XWbH3/9K8=";

  nativeBuildInputs = with pkgs; [ openssl pkg-config ];

  buildInputs = with pkgs; [ rustfmt clippy rust-analyzer ];

  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}

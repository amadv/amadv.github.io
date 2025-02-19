{ pkgs, stdenv }:
stdenv.mkDerivation rec {
  pname = "amadv.github.io";
  version = "0.1.0";

  dontPatch = true;

  installFlags = "PREFIX=${placeholder "out"} VERSION=${version}";

  preBuild = ''
    patchShebangs bin/*.sh
  '';

  buildPhase = ''
    mkdir -p "$out/srv/amadv.github.io"
    python3 gen.py "$out/srv/amadv.github.io"
  '';

  installPhase = ''

  '';

  buildInputs = with pkgs; [
    gawk gnused rsync darkhttpd
    (python3.withPackages(ps: with ps; [
      jinja2
      markdown
    ]))
    ruff
    texlive.combined.scheme-small
    pandoc
  ];

  src = ./.;

  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}

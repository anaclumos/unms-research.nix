{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  glib,
  glib-networking,
  openssl,
  libsoup_3,
  sources,
}:

stdenv.mkDerivation rec {
  inherit (sources.research) pname version src;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    glib
    glib-networking
    openssl
    libsoup_3
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/bin/research $out/bin/

    mkdir -p $out/share
    cp -r usr/share/icons $out/share/
    cp -r usr/share/applications $out/share/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Read more research";
    homepage = "https://un.ms/research";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "research";
  };
}

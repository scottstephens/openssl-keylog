{ pkgs ? (import <nixpkgs> {}), buildLocal ? false } :
with pkgs;
stdenv.mkDerivation rec {
  name = "openssl-keylog";
  src = 
    if buildLocal then
      nix-gitignore.gitignoreSource [] ./. 
    else 
      fetchgit {
        url = "https://github.com/wpbrown/openssl-keylog.git";
        rev = "68437dc58df044e70898bf5289a510386ff5f63b";
        sha256 = "sha256-gIj7Nr+LsMexLFNhoIdNgLEUXwqKgzuEomsRJKMmpF0=";
      }
  ;
  buildInputs = [];
  configurePhase = "";
  installPhase = ''
    echo ""
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share/sslkeylog/preload
    cp ./libsslkeylog.so $out/share/sslkeylog/preload/libsslkeylog.so
    cp ./sslkeylogged $out/bin
    cp ./dumpcapssl $out/bin
  '';
}


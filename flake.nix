{
  description = "CI/CD config for GitHub Actions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        dependencies = with pkgs; [ bash coreutils clang cmake ninja act ];
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "template";
          buildInputs = dependencies;
          src = ./.;
          dontUseCmakeConfigure = true;
          buildPhase = ''
            export CC=${pkgs.clang}/bin/clang
            export CXX=${pkgs.clang}/bin/clang++
            $src/build.sh
          '';
          installPhase = "cmake --install build --prefix $out";
        };
        # packages.image = pkgs.dockerTools.buildLayeredImage {
        #   name = "template-image";
        #   tag = "latest";
        #   contents = dependencies;
        #   config.cmd 
        # };
        devShells.default = pkgs.mkShell { packages = dependencies; };
      });
}

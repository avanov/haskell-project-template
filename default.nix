{}:

let
    commonEnvs = builtins.fetchGit {
        url = "https://github.com/avanov/nix-common.git";
        ref = "master";
        rev = "9d81a5757aa0dfb7ca68edccd081bdf591c6df9e";
    };
    ghcEnv  = import "${commonEnvs}/ghc-env.nix" {};
    pkgs    = ghcEnv.pkgs;

    macOsDeps = with pkgs; lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.CoreServices
        darwin.apple_sdk.frameworks.ApplicationServices
    ];

    devEnv  = pkgs.mkShell {
        # Sets the build inputs, i.e. what will be available in our
        # local environment.
        nativeBuildInputs = with pkgs; [
            cabal-install
            cabal2nix
            cachix

            cacert
            glibcLocales

            gnumake
            gitAndTools.pre-commit
            haskell-language-server
            ghc

            zlib
        ] ++ macOsDeps;
        shellHook = ''
            export PROJECT_PLATFORM="${builtins.currentSystem}"
            export LANG=en_GB.UTF-8

            # https://cabal.readthedocs.io/en/3.4/installing-packages.html#environment-variables
            export CABAL_DIR=$PWD/.local/${builtins.currentSystem}/cabal

            # Dirty fix for Linux systems
            # https://nixos.wiki/wiki/Packaging/Quirks_and_Caveats
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
            # symbolic link to Language Server to satisfy VSCode Haskell plugins
            ln -s -f `which haskell-language-server` $PWD/hls.exe
        '';
    };

in

{
    inherit devEnv;
}

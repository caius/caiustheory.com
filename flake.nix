{
  description = "caiustheory.com";

  inputs = {
    # Contains hugo 0.92.1
    nixpkgs.url = "github:NixOS/nixpkgs/04e546b93148b4c31026a14fb3edae876816105e";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.hugo
        ];
      };
    }
  );
}

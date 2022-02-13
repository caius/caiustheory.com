{
  description = "caiustheory.com";

  inputs = {
    # Contains hugo 0.92.1
    nixpkgs.url = "github:NixOS/nixpkgs/04e546b93148b4c31026a14fb3edae876816105e";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    devShell.aarch64-darwin = pkgs.mkShell {
      buildInputs = [
        pkgs.hugo
      ];
    };
  };
}

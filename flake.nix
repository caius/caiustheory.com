{
  description = "caiustheory.com";

  inputs = {
    # Check for new releases at https://github.com/NixOS/nixpkgs/commits/master/pkgs/applications/misc/hugo/default.nix
    # 0.92.2
    nixpkgs.url = "github:NixOS/nixpkgs/2186c8c5834826ef71099a85becd5465768dd843";

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
          pkgs.terraform
        ];
      };
    }
  );
}

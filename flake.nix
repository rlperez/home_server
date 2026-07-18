{
  description = "Homelab Ansible environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              ansible
              ansible-lint
              jq
              curl
              vault
            ];

            shellHook = ''
              echo "Homelab Ansible environment"
              echo "Ansible: $(ansible --version | head -1)"
              echo "Ansible Lint: $(ansible-lint --version)"
              echo "Vault: $(vault --version)"
              echo "Curl: $(curl --version | head -1)"
              echo "Jq: $(jq --version)"
            '';
          };
        });
    };
}

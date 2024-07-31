{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }@ inputs:
    let
      ehbrSSHKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0ppSVZ8+TdP7ZIRJZNwCAopAQHo0mdLZVWbf/uSWBY ehbr@ehbr'';
      rootSSHKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGwEAvQ1079PtLiS/wly3gOrVtC/NWuaB1tBQy/PEzJ root@ehbr'';
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        {
          inputs = inputs;
          pkgs = nixpkgs.legacyPackages.${system};
        });

      nixosConfigurations = {
        builder-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            ehbrSSHKey = ehbrSSHKey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            ./systems/builder/config.nix
          ];
        };
        builder-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            ehbrSSHKey = ehbrSSHKey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            ./systems/builder/config.nix
          ];
        };
      };
    };
}

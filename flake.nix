{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    nur.url = "github:nix-community/NUR";
    darwin.url = "github:lnl7/nix-darwin/master";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    nur,
    darwin,
    nix-homebrew,
    ...
  } @ inputs: let 
    inherit (self) outputs;

    # Supported Systems
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      jade = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/jade
          ./hosts/shared
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "jade";

            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = ["nixpkgs=flake:nixpkgs"];

            home-manager = {
              users.alex = ./homes/jade;
              extraSpecialArgs = {inherit inputs outputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.nur.hmModules.nur
                inputs.sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      ruby = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/ruby
          ./hosts/shared
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "ruby";

            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = ["nixpkgs=flake:nixpkgs"];

            home-manager = {
              users.alex = ./homes/ruby;
              extraSpecialArgs = {inherit inputs outputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.nur.hmModules.nur
                inputs.sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      jet = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/jet
          ./hosts/shared
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "jet";

            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = ["nixpkgs=flake:nixpkgs"];

            home-manager = {
              users.alex = ./homes/jet;
              extraSpecialArgs = {inherit inputs outputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.nur.hmModules.nur
                inputs.sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      onyx = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs {system = "aarch64-darwin";};
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/onyx
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            networking = let
              name = "onyx";
            in {
              computerName = name;
              hostName = name;
              localHostName = name;
            };
            
            home-manager = {
              users.alex = ./homes/onyx;
              extraSpecialArgs = {inherit inputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.nur.hmModules.nur
                inputs.sops-nix.homeManagerModules.sops
              ];
            };

            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "alex";
              autoMigrate = true;
              #mutableTaps = false; # breaks declaring taps in homebrew.taps
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      opal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/opal
          ./hosts/shared
          {
            networking.hostName = "opal";

            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = ["nixpkgs=flake:nixpkgs"];
          }
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}

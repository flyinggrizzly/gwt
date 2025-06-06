{
  description = "gwt - an opinionated git worktree manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Define the package directly in the flake
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "gwt";
          version = "0.1.0";

          src = ./.;

          dontBuild = true;

          installPhase = ''
            mkdir -p $out/share/zsh

            # Copy the single function file
            cp gwt $out/share/zsh/

            # Create simple init script
            cat > $out/share/zsh/init.zsh << 'EOF'
              source $out/share/zsh/gwt
            EOF

            # Replace $out placeholder with actual path
            sed -i "s|\$out|$out|g" $out/share/zsh/init.zsh

            # Make function file executable
            chmod +x $out/share/zsh/gwt
          '';

          meta = with pkgs.lib; {
            description = "gwt - an opinionated git";
            license = licenses.gpl3;
            platforms = platforms.all;
          };
        };

        # Development shell for testing
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ zsh ];
          shellHook = ''
            echo "🧪 Testing environment for zsh functions"
            echo "📦 Package: ${self.packages.${system}.default}"
          '';
        };
      }
    )) // {
      homeManagerModules.default =
        { pkgs, ... }:
        {
          programs.zsh.initContent = ''
            source ${self.packages.${pkgs.system}.default}/share/zsh/init.zsh
          '';
        };
    };
}

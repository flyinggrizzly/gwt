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
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "gwt";
          version = "0.2.0";
          src = ./.;
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/share/zsh
            cp gwt $out/share/zsh/
            cat > $out/share/zsh/init.zsh << 'EOF'
              source $out/share/zsh/gwt
            EOF
            sed -i "s|\$out|$out|g" $out/share/zsh/init.zsh
            chmod +x $out/share/zsh/gwt
          '';

          meta = with pkgs.lib; {
            description = "gwt - an opinionated git worktree manager";
            license = licenses.gpl3;
            platforms = platforms.all;
          };
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

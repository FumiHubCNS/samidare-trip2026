{
  description = "TRIP 2026 exp analysis environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        python = pkgs.python313;
        jdk = pkgs.jdk17;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            python
            pkgs.uv
            pkgs.git
            jdk
          ];

          env = {
            JAVA_HOME = "${jdk}";
            UV_PYTHON = "${python}/bin/python";
            UV_PYTHON_DOWNLOADS = "never";
          };

          shellHook = ''
            echo "TRIP 2026 analysis environment"
            echo "Python: $(python --version)"
            echo "uv:     $(uv --version)"
            echo "Java:   $(java -version 2>&1 | head -n 1)"

            if [ -d ".venv" ]; then
              source .venv/bin/activate
            else
              echo ""
              echo "No .venv found."
              echo "Run: uv sync"
            fi
          '';
        };
      });
}

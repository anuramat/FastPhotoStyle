{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
            cudnnSupoprt = true;
          };
        };
      in {
        devShell = pkgs.mkShell {
          # shellHook = ''
          #   export CUDA_PATH=${pkgs.cudatoolkit}
          #   export PATH=${pkgs.cudatoolkit}/bin:$PATH
          #   export LD_LIBRARY_PATH=${pkgs.cudatoolkit}/bin64:$LD_LIBRARY_PATH
          #   export C_INCLUDE_PATH=${pkgs.cudatoolkit}/include
          # '';
          buildInputs = [
            (pkgs.python3.withPackages (python-pkgs:
              with python-pkgs; [
                jupyter
                jupytext
                numpy
                scipy
                scikit-learn
                matplotlib
                tqdm
                torch
                torchvision
                cupy
                pycuda
                pytorch-lightning # import as `pytorch_lightning`
                pytest
                tensorboard
              ]))
            pkgs.cudaPackages.cudatoolkit
          ];
        };
      }
    );
}

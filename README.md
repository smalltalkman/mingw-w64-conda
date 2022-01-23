# mingw-w64-conda

## Build all
```
 > ./build.sh -f build_order -32  
 > ./build.sh -f build_order -64  
 > pacman -Rs --noconfirm mingw-w64-{i686,x86_64}-binutils
```

## Install/Uninstall conda
```
 > pacman -S --asdeps --needed --noconfirm mingw-w64-{i686,x86_64}-conda
 > pacman -Rs                  --noconfirm mingw-w64-{i686,x86_64}-conda
 > rm -rf /mingw{32,64}/{pkgs,envs}
```

## Test conda
```
 > conda --version
 > conda --help
 > conda info -e
 > conda info --all
 > conda init --dry-run

 > conda search openjdk

 > conda create -n test

 > conda activate  test
 > conda install openjdk=8.0.152
 > conda list
 > which java
 > java -version
 > java -help
 > conda remove  openjdk=8.0.152
 > conda list
 > conda deactivate

 > conda remove -n test --all

 > conda-env --help
 > conda-env list
 > conda-env remove --name test

```

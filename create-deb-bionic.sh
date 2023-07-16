#!/bin/bash

DIRECTORY="/github/workspace"
export DEBIAN_FRONTEND=noninteractive

LATESTCOMMIT=`cat $DIRECTORY/commit-bionic.txt`

function error() {
	echo -e "\e[91m$1\e[39m"
    rm -f $COMMITFILE
    rm -rf $DIRECTORY/box86
	exit 1
 	break
}

rm -rf $DIRECTORY/box86

cd $DIRECTORY

# install dependencies
apt-get update
apt-get install wget git build-essential gcc-8 python3 make gettext pinentry-tty sudo devscripts dpkg-dev -y || error "Failed to install dependencies"
git clone https://github.com/ryanfortner/checkinstall || error "Failed to clone checkinstall repo"
cd checkinstall
sudo make install || error "Failed to run make install for Checkinstall!"
cd .. && rm -rf checkinstall
sudo apt install -yf ./resources/cmake_3.24.2-25.1_armhf.deb || error "Failed to install latest cmake package!"

rm -rf box86

git clone https://github.com/ptitSeb/box86 || error "Failed to download box86 repo"
cd box86
commit="$(bash -c 'git rev-parse HEAD | cut -c 1-7')"
if [ "$commit" == "$LATESTCOMMIT" ]; then
  cd "$DIRECTORY"
  rm -rf "box86"
  echo "Box86 is already up to date. Exiting."
  touch exited_successfully.txt
  exit 0
fi
echo "box86 is not the latest version, compiling now."
echo $commit > $DIRECTORY/commit-bionic.txt
echo "Wrote commit to commit-bionic.txt file for use during the next compilation."

targets=(ARM64 ANDROID RPI4ARM64 RPI3ARM64 TEGRAX1 RK3399)

for target in ${targets[@]}; do
  echo "Building $target"

  cd $DIRECTORY/box86
  sudo rm -rf build && mkdir build && cd build || error "Could not move to build directory"
  if [[ $target == "ANDROID" ]]; then
    cmake .. -DARM64=1 -DBAD_SIGNAL=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=gcc-8 || error "Failed to run cmake."
  else
    cmake .. -D$target=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=gcc-8 || error "Failed to run cmake."
  fi
  make -j4 || error "Failed to run make."

  function get-box86-version() {
    if [[ $1 == "ver" ]]; then
      export BOX86VER="$(./box86 -v | cut -c21-25)"
    elif [[ $1 == "commit" ]]; then
      export BOX86COMMIT="$commit"
    fi
  }

  get-box86-version ver  || error "Failed to get box86 version!"
  get-box86-version commit || error "Failed to get box86 commit!"
  DEBVER="$(echo "$BOX86VER+$(date +"%F" | sed 's/-//g').$BOX86COMMIT")" || error "Failed to set debver variable."

  mkdir doc-pak || error "Failed to create doc-pak dir."
  cp ../docs/README.md ./doc-pak || warning "Failed to add README to docs"
  cp ../docs/CHANGELOG.md ./doc-pak || error "Failed to add CHANGELOG to docs"
  cp ../docs/USAGE.md ./doc-pak || error "Failed to add USAGE to docs"
  cp ../docs/X86WINE.md ./doc-pak || error "Failed to add X86WINE to docs"
  cp ../LICENSE ./doc-pak || error "Failed to add LICENSE to docs"
  echo "Box86 lets you run x86 Linux programs (such as games) on non-x86 Linux systems, like ARM (host system needs to be 32bit little-endian)">description-pak || error "Failed to create description-pak."
  echo "#!/bin/bash
  echo 'Restarting systemd-binfmt...'
  systemctl restart systemd-binfmt || true" > postinstall-pak || error "Failed to create postinstall-pak!"

  conflict_list="qemu-user-static"
  for value in "${targets[@]}"; do
    if [[ $value != $target ]]; then
      [[ $value == "ARM64" ]] && value="GENERIC_ARM"
      conflict_list+=", box86-$(echo $value | tr '[:upper:]' '[:lower:]' | tr _ - | sed -r 's/ /, /g')"
    fi
  done
  if [[ $target == "ARM64" ]]; then
    sudo checkinstall -y -D --pkgversion="$DEBVER" --arch="armhf" --provides="box86" --conflicts="$conflict_list" --pkgname="box86-generic-arm" --install="no" make install || error "Checkinstall failed to create a deb package."
  else
    sudo checkinstall -y -D --pkgversion="$DEBVER" --arch="armhf" --provides="box86" --conflicts="$conflict_list" --pkgname="box86-$target" --install="no" make install || error "Checkinstall failed to create a deb package."
  fi

  cd $DIRECTORY
  mv box86/build/*.deb ./debian/ || error "Failed to move deb to debian folder."

done

rm -rf $DIRECTORY/box86

echo "Script complete."

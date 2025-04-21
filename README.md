# box86-debs

This is a simple Debian repository for the [box86](https://github.com/ptitSeb/box86) project. New versions are compiled every 24 hours if a new commit on box86's repository has been made, you can find all the debs here: https://github.com/ryanfortner/box86-debs/commits/master

These debs have been compiled using various target CPUs and systems. You can see all the available pkgs below.

## Package List
***SPECIAL NOTE: all packages are compiled for native armhf, even the ones with ARM64 in their target name! It's possible to run them on arm64 systems but you need to either run a [multiarch](https://github.com/ryanfortner/box86-debs#running-box86-on-arm64-systems) or [compile from source](https://github.com/ptitSeb/box86/blob/master/docs/COMPILE.md#for-other-arm64-64bits-linux-platform).***

Package Name | Target Distro | Notes | Install Command |
------------ | ------------- | ------------- | ------------- |
| box86-rpi4arm64 | >= Ubuntu 22.04 | box86 built for RPI4ARM64 target. | `sudo apt install box86-rpi4arm64` |
| box86-rpi3arm64 | >= Ubuntu 22.04 | box86 built for RPI3ARM64 target. | `sudo apt install box86-rpi3arm64` |
| box86-generic-arm | >= Ubuntu 22.04 | box86 built for generic ARM systems. | `sudo apt install box86-generic-arm` |
| box86-tegrax1 | >= Ubuntu 22.04 | box86 built for Tegra X1 systems. | `sudo apt install box86-tegrax1` |
| box86-rk3399 | >= Ubuntu 22.04 | box86 built for rk3399 cpu target. | `sudo apt install box86-rk3399` |
| box86-android | >= Ubuntu 22.04 | box86 built with the `-DBAD_SIGNAL=ON` flag | `sudo apt install box86-android` |
| box86-rk3588 | >= Ubuntu 22.04 | box86 built for rk3588 target | `sudo apt install box86-rk3588` |
| box86-sd845 | >= Ubuntu 22.04 | box86 built for Snapdragon 845 target | `sudo apt install box86-sd845` |
| box86-sd888 | >= Ubuntu 22.04 | box86 built for Snapdragon 888 target | `sudo apt install box86-sd888` |

Want me to build for more platforms? Open an issue. 

### Repository installation
Involves adding .list file and gpg key for added security.
```
sudo wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 
sudo apt update && sudo apt install box86-rpi4arm64 -y
```

If you don't want to add this apt repository to your system, you can download and install the latest armhf deb from [here](https://github.com/ryanfortner/box86-debs/tree/master/debian).

### Running box86 on ARM64 Systems
It's possible to run box86 on an arm64 machine, but you need to add the armhf architecture through dpkg and then the appropriate package with the :armhf tag following. See the below example.
```
sudo dpkg --add-architecture armhf
sudo apt-get update
# proceed to add the repo using instructions above
sudo apt-get install box86-rpi4arm64:armhf
```

### Note for box64

Please note that this repository is *only for box86*. If you would like deb packages for box64, check out [box64-debs](https://github.com/ryanfortner/box64-debs)


#### Technical details
Build scripts were split into two: one for Ubuntu Bionic (which builds on gcc-8) and one for Ubuntu Focal (which builds on gcc-9). Some newer targets require gcc-9 which is why I have that script. The goal is to compile each build with the best compatibility with most widely-used debian systems.

When adding a target to the build scripts, make sure `alltargets` variable in both buildscripts is updated. This ensures that the conflicts list within each deb is written correctly.

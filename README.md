# Box86 Debian Packaging

This is a simple Debian repository for the [box86](https://github.com/ptitSeb/box86) project. It uses `debuild` and `dh_make` to compile and package box86.

### DEB files
To install the latest version of box86 you can simply download the latest version and install it with dpkg:
```
wget https://ryanfortner.github.io/box86-debs/box86-latest.deb
sudo dpkg -i box86-latest.deb
```

And uninstall it with `sudo apt purge box86`

### APT repository
The apt repository will not be updated for now, but it is still active, 
```
sudo wget https://ryanfortner.github.io/box86-debs/apt-repo/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://ryanfortner.github.io/box86-debs/apt-repo/KEY.gpg | sudo apt-key add -
sudo apt update && sudo apt install box86 -y
```

### Packaging
```
git clone https://github.com/ptitSeb/box86.git && cd box86
dpkg-buildpackage -us -uc -nc
# package will be in the parent directory
```

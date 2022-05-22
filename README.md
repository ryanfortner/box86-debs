# box86-debs

This is a simple Debian repository for the [box86](https://github.com/ptitSeb/box86) project. New versions are compiled every 24 hours if a new commit on box86's repository has been made, you can find all the debs here: https://github.com/ryanfortner/box86-debs/commits/master

### Repository installation
Involves adding .list file and gpg key for added security.
```
sudo wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
wget -O- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/box86-debs-archive-keyring.gpg
sudo apt update && sudo apt install box86 -y
```

If you don't want to add this apt repository to your system, you can download and install the latest armhf deb from [here](https://github.com/ryanfortner/box86-debs/tree/master/debian).

### Note for box64

Please note that this repository is *only for box86*. If you would like deb packages for box64, check out [box64-debs](https://github.com/ryanfortner/box64-debs)
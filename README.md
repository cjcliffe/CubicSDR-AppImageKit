# CubicSDR-AppImageKit
AppImageKit build scripts (Debian Jessie base)

Recommend build environment is a dedicated VM.
If you have [vagrant](https://www.vagrantup.com/) installed you can use it to easily provision a build VM.     
Simply run:  

```
$ vagrant up
$ vagrant ssh
$ cd /vagrant
$ make
```
You will find the `.AppImage` in the repository root once the build finishes.
You can then get rid of the VM by running `vagrant destroy`.     

Alternatively, you can provision a machine manually:  

```
$ chmod +x scripts/bootstrap_debian_jessie.sh
$ scripts/bootstrap_debian_jessie.sh
```

Build AppImage:  

```
$ make
```


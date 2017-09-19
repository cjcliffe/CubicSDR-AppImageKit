# CubicSDR-AppImageKit
AppImageKit build scripts (Ubuntu 14.04 base)

Recommend build environment is a dedicated Ubuntu VM.
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
$ chmod +x scripts/bootstrap_ubuntu14_04.sh
$ scripts/bootstrap_ubuntu14_04.sh
```

Build AppImage:  

```
$ make
```


# CubicSDR-AppImageKit
AppImageKit build scripts (CentOS 8 base)

Vagrant is required for the build environment. If you don't have [vagrant](https://www.vagrantup.com/) installed, please install it first. Then, you can easily provision and connect to a build VM by running the following commands:
```
$ vagrant up
$ vagrant ssh
```

After connecting to the vagrant environment via SSH, run the following commands:
```
$ cd /vagrant
$ make
```

The compilation should complete and produce an `.AppImage` file in the in `/vagrant/` directory

To exit the vagrant environment, run:
```
$ exit
```

Next, copy the AppImage file to your local machine using the following commands:
```
$ vagrant plugin install vagrant-scp  # if not already installed
$ vagrant scp default:/vagrant/*.AppImage .
```

You should now have the final `.AppImage` file in your folder.

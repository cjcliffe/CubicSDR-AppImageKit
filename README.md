# CubicSDR-AppImageKit
AppImageKit build scripts (CentOS 8 base)

We use a dedicated VM as the build environment. With [vagrant](https://www.vagrantup.com/) installed, you can easily provision a build VM. Simply run:
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

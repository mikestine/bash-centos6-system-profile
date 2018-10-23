## CentOS6 System Profile

Profiles a machine running CentOS6.  Prints OS and hardware information including: hostname, network, chassis, bios, processor, memory, block device, mounted file system, system slots.

### Usage

Run locally

```
./centos6_system_profile.sh
```
Or run remotely
```
ssh -p22 root@10.102.1.111 "bash -s" -- < centos6_system_profile.sh
```

## Authors

* **Mike Stine** - *Initial work* - [MikeStine](https://github.com/MikeStine)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

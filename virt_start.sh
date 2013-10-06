
sudo virt-install -r 1024 -n bcpc-bootstrap -f /var/lib/libvirt/images/bcpc.img --network=network:default --network=network:floats --network=network:storage --network=network:mgmt --cdrom=/home/rick/Downloads/mini.iso


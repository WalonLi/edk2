rm debug.log

# configure bridge and tap (with host nic)
    # sudo brctl addbr br0				#create bridge
    # sudo ip addr flush dev enp3s0 		#clear IP of eth0
    # sudo brctl addif br0 eth0			#interface to br0
    # sudo ip tuntap add tap0 mode tap 	#create tap device
    # sudo brctl addif br0 tap0			#interface to br0
    # sudo ifconfig eth0 up
    # sudo ifconfig tap0 up
    # sudo ifconfig br0 up
    # sudo brctl show
    # sudo dhclient -v br0 				#assign ip to bridge

# configure bridge and tap (with internal only)
    # sudo brctl addbr br1				#create bridge
    # sudo ip tuntap add tap0 mode tap 	#create tap device
    # sudo brctl addif br1 tap0			#interface to br0
    # sudo ifconfig tap0 up
    # sudo ifconfig br1 up
    # sudo ifconfig br1 172.16.1.1 255.255.255.0 172.16.1.1
    # sudo brctl show
    # sudo systemctl restart isc-dhcp-server
	#






    
	# set static ip for br1 and add below to dhcpd.conf
	# host br1 {
    #   hardware ethernet BR1_MAC;
    #   fixed-address STATIC_BR1_IP;
	# }
	#


# build script
# . edksetup.sh
# build -D NETWORK_HTTP_BOOT_ENABLE -D NETWORK_TLS_ENABLE -D NETWORK_ALLOW_HTTP_CONNECTIONS
# build -p OvmfPkg/OvmfPkgX64.dsc -a X64 -t GCC5 -b DEBUG

# backup...
# -global e1000.romfile="efi-e1000.rom" \
# -net nic\
# -fw_cfg name=/home/walon/Desktop/Project/edk2,file=ciphers.bin \

# qemu backup.
# have to upgrade to qemu 8.x and build by yourself.
# ./configure --enable-gtk  # This for enable GUI.


sudo qemu-system-x86_64 \
	-pflash Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd \
	-debugcon stdio \
	-global isa-debugcon.iobase=0x402 \
  	-netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
	-device virtio-net-pci,netdev=net0 \
	-drive file=image.img\
	-display gtk \
	-enable-kvm 2>&1 \
    -fw_cfg name=ciphers_walon.bin,file=ciphers_walon.bin \
	| tee debug.log
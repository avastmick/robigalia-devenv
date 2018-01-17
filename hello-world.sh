###########################################################
#
# Tests the Robigalia development environment within the 
# Docker container created by setup.sh
###########################################################

echo "Building Hello World binaries..."
cd sel4 && make x64_qemu_defconfig && make 

cd ../hello-world && xargo build --target x86_64-sel4-robigalia && cd ..

echo "Check the output and look for errors. There may be some rustc warns."
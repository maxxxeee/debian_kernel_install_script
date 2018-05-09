#!/bin/sh
# This is a comment!
threadCount=echo grep -c ^processor /proc/cpuinfo
#currenPath=echo pwd
#pathToCdTo=echo pwd
#pathToCdTo+="/linux-v4.17-rc4/"

while true; do
    read -p "'$threadCount' usable threads for compiling were found. Do you wish to override this value? [yes] [no] " yn
    case $yn in
        [Yy]* ) echo "pleas insert the desired thread count:"; read threadCount; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "#####"
echo "downloading the linux kernel 4.17rc4 source from github"
echo "#####"
wget "https://codeload.github.com/torvalds/linux/zip/v4.17-rc4" || { echo 'source download failed!' ; exit 1; }
#&&
echo "#####"
echo "unzipping in current directory"
echo "#####"
unzip "v4.17-rc4" || { echo 'unzipping of source file failed!' ; exit 1; }
#&&
echo "#####"
echo "cleaning up source folder"
echo "#####"
make -C ./linux-4.17-rc4/ clean && make -C ./linux-4.17-rc4/  mrproper || { echo 'cleaning up the source files failed!' ; exit 1; }
#&&
echo "#####"
echo "creating kernel config based on the currentlz in use kernel of this machine. also enabling as many new features of the new kernel as possible"
echo "#####"
"" yes | make -C ./linux-4.17-rc4/  oldconfig || { echo 'creating oldconfig failed!' ; exit 1; }
#&&
echo "#####"
echo "compiling kernel and creating debian packages"
echo "#####"
make -j $threadCount -C ./linux-4.17-rc4/  deb-pkg LOCALVERSION=-4.17rc4 || { echo 'creating the kernel debian packages failed!' ; exit 1; }
#&&
echo "#####"
echo "installing kernel to system"
echo "#####"
sudo dpkg -i *.deb || { echo 'installing kernel debian packages failed!' ; exit 1; }
echo "#####"
echo "All done!"
echo "#####"

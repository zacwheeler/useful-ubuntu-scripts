#!/bin/bash
RELEASE=`lsb_release -a 2>/dev/null | grep Release | awk '{ print $2 }'`
USERNAME=`whoami`
CMDS="prebuilt/linux-x86/ccache/ccache -M 50G"
echo "Installing for $RELEASE. Make sure you don't mind losing any existing java installs."

sudo apt-get purge sun-java*
wget https://github.com/flexiondotorg/oab-java6/raw/0.2.6/oab-java.sh -O oab-java.sh
chmod +x oab-java.sh
sudo ./oab-java.sh
sudo apt-get update
sudo apt-get install sun-java6-plugin sun-java6-jre sun-java6-bin sun-java6-jdk
rm -rf ~/tmp-oab-java6.git


if [ $RELEASE == "12.04" ] ; then
sudo apt-get install git-core gnupg flex bison gperf build-essential \
  zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
  libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
  libgl1-mesa-dev g++-multilib mingw32 openjdk-6-jdk tofrodos \
  python-markdown libxml2-utils xsltproc zlib1g-dev:i386
sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
elif [ $RELEASE == "11.10" || $RELEASE == "11.04" || $RELEASE == "10.10" || $RELEASE == "10.04" ] ; then
sudo apt-get install git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs \
  x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev \
  libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown \
  libxml2-utils xsltproc
fi

if [ $RELEASE == "10.10" ] ; then
	sudo ln -s /usr/lib32/mesa/libGL.so.1 /usr/lib32/mesa/libGL.so
elif [ $RELEASE == "11.10" ] ; then
	sudo apt-get install libx11-dev:i386
fi

sudo sh -c "echo \
'# adb protocol on passion (Nexus One)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e12", MODE="0600", OWNER="$USERNAME" 
# fastboot protocol on passion (Nexus One)
SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0fff", MODE="0600", OWNER="$USERNAME" 
# adb protocol on crespo/crespo4g (Nexus S)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e22", MODE="0600", OWNER="$USERNAME" 
# fastboot protocol on crespo/crespo4g (Nexus S)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e20", MODE="0600", OWNER="$USERNAME"
# adb protocol on stingray/wingray (Xoom)
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", ATTR{idProduct}=="70a9", MODE="0600", OWNER="$USERNAME"
# fastboot protocol on stingray/wingray (Xoom)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="708c", MODE="0600", OWNER="$USERNAME"
# adb protocol on maguro/toro (Galaxy Nexus)
SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="6860", MODE="0600", OWNER="$USERNAME"
# fastboot protocol on maguro/toro (Galaxy Nexus)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e30", MODE="0600", OWNER="$USERNAME"
# adb protocol on panda (PandaBoard)
SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d101", MODE="0600", OWNER="$USERNAME"
# fastboot protocol on panda (PandaBoard)
SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d022", MODE="0600", OWNER="$USERNAME"
# usbboot protocol on panda (PandaBoard)
SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d00f", MODE="0600", OWNER="$USERNAME"
# usbboot protocol on panda (PandaBoard ES)
SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d010", MODE="0600", OWNER="$USERNAME"
# adb protocol on grouper (Nexus 7)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e42", MODE="0600", OWNER="$USERNAME"
# fastboot protocol on grouper (Nexus 7)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e40", MODE="0600", OWNER="$USERNAME" \
' > /etc/udev/rules.d/51-android.rules"

echo "export USE_CCACHE=1" >> ~/.bashrc

echo "Run the following command(s) after downloading the source: $CMDS"

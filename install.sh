#!/bin/sh

# script to automatically do the following steps:
#   - install the dependencies to compile the program, i.e. install 'gcc', 'make' and 'libhidapi-dev'
#     remark: once the program is compiled, 'libhidapi-dev' isn't required any more, only 'libhidapi-libusb0' is
#   - compile the program
#   - move the program 'msiklm' to '/usr/local/bin/msiklm'
#   - run 'msiklm' with 'test' option to check if the keyboard is detected

echo "Installation script for MSIKLM - MSI Keyboard Light Manager"
echo "###########################################################"
sleep 1

echo "Installing dependencies..."
sleep 2

if (command which yum); then
    if (sudo yum install -y gcc make hidapi-devel); then
      echo "Detected as CENTOS-based && dependencies successfully installed"
      sleep 2
    else
      echo "Dependencies could not be installed"
    fi
elif (command which apt); then
    if (sudo apt install -y gcc make libhidapi-dev); then
      echo "Detected as DEBIAN-based && dependencies successfully installed"
    else
      echo "Dependencies could not be installed"
    fi
else
    echo "Dependencies could not be installed"
    exit 1
fi

echo "Compiling 'msiklm'..."
sleep 2

# compile
if (make); then
    echo "Compiling finished successfully"
    sleep 2
else
    echo "Compiling failed"
    exit 1
fi

# install 'msiklm' to '/usr/local/bin/msiklm' which also makes it callable via the msiklm command
if (sudo make install); then
    make delete
    echo "Installation of 'msiklm' finished successfully"
    sleep 2
else
    echo "Installation of 'msiklm' failed"
    exit 1
fi;

echo "Testing 'msiklm'..."
sleep 1

if (sudo msiklm test); then
    echo "To configure the keyboard run 'msiklm' with your configuartion of choice, for a list of valid commands run 'msiklm help'."
    echo "If you want to enable the autostart, run 'autostart.sh' with your configuartion of choice, to uninstall 'msiklm' run 'uninstall.sh'."
    echo "Thank you for using 'msiklm' and have fun with it! :-)"
    echo "Enable usage"
    sleep 1

    if (sudo mv -fv msiklm /usr/local/bin/msiklm); then
        echo "Software was moved to /usr/local/bin/msiklm"
        sleep 1

        if (sudo chmod 755 /usr/local/bin/msiklm); then
            echo "Permissions was set 755 to /usr/local/bin/msiklm"
            sleep 1

            if (sudo msiklm white); then
                echo "Set white color"
                sleep 1

                if (bash ./autostart white); then
                    echo "Enable autostart with white color"
                else
                    echo "Failed to enable autostart"
                fi

            echo "Finished"

            else
                echo "Failed to set white color"
            fi
        else
          echo "Failed to set permissions 755 on /usr/local/bin/msiklm"
        fi
    else
        echo "Failed to move software into /usr/local/bin/msiklm"
    fi

else
    echo "Testing of 'msiklm' failed"
fi
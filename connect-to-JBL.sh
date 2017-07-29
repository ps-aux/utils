#!/bin/env bash
set -e
echo "Connecting to JBL Bluetooth speaker"
sudo systemctl start bluetooth.service
mac=$(bluetoothctl <<< "exit" | sed -rn 's/^.*Device ((..:?)*).*JBL.*/\1/p')
echo ${mac}
bluetoothctl connect ${mac}


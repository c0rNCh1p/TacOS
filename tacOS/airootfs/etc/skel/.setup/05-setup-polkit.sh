#!/bin/bash
sudo chown root:polkitd "/etc/polkit-1/rules.d" >"/dev/null" 2>&1
sudo find "/etc/polkit-1/rules.d" -type f -exec chmod 750 "/etc/polkit-1/rules.d" {} \; >"/dev/null" 2>&1
sudo find "/etc/polkit-1/rules.d" -type f -exec chown root:polkitd "/etc/polkit-1/rules.d" {} \; >"/dev/null" 2>&1

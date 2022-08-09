#!/bin/bash
__PLACEHOLDER_UNIX_USERS__
__PLACEHOLDER_EXTRA_CMD__
__PLACEHOLDER_SUDOERS__
/etc/init.d/apache2 start
/etc/init.d/ssh start
ruby /root/boss.rb
#!/bin/bash
set -ex
hhvm --version
curl https://getcomposer.org/installer | hhvm -d hhvm.jit=0 --php -- /dev/stdin --install-dir=/usr/local/bin --filename=composer

cd /var/source
hhvm -d xdebug.enable=0 -d hhvm.jit=0 -d hhvm.hack.lang.auto_typecheck=0 /usr/local/bin/composer install
hhvm -d xdebug.enable=0 -d hhvm.jit=0 vendor/bin/hacktest tests/

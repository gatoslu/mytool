#!/usr/bin/env bash
wget -N --no-check-certificate https://raw.githubusercontent.com/gatoslu/mytool/master/vpstool/cpulimit.sh && chmod +x cpulimit.sh

mv cpulimit.sh /cpulimit.sh
bash cpulimit.sh

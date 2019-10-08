#!/bin/bash

# Copyright 2018-present, Yudong (Dom) Wang
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------------------
# Holer Setup Script
# -----------------------------------------------------------------------------
cd `dirname $0`/..

HOLER_OK=0
HOLER_ERR=1

HOLER_HOME=`pwd`
HOLER_BIN=$HOLER_HOME/bin
HOLER_CONF=$HOLER_HOME/conf/holer.conf
HOLER_SERVICE="holer.service"
SYSD_DIR="/lib/systemd/system"

function input() 
{
    # Asking for the holer access key
    if [ "$HOLER_ACCESS_KEY" == "" ]; then
        echo "Enter holer access key:"
        read HOLER_ACCESS_KEY
        if [ "$HOLER_ACCESS_KEY" == "" ]; then
            echo "Please enter holer access key."
            exit $HOLER_ERR
        fi
        echo "HOLER_ACCESS_KEY=$HOLER_ACCESS_KEY" > $HOLER_CONF
    fi

    # Asking for the holer server host
    if [ "$HOLER_SERVER_HOST" == "" ]; then
        echo "Enter holer server host:"
        read HOLER_SERVER_HOST
        if [ "$HOLER_SERVER_HOST" == "" ]; then
            echo "Please enter holer server host."
            exit $HOLER_ERR
        fi
        echo "HOLER_SERVER_HOST=$HOLER_SERVER_HOST" >> $HOLER_CONF
    fi
}

function setup()
{
    input
    cp $HOLER_BIN/$HOLER_SERVICE $SYSD_DIR/
    sed -i "s|@HOLER_HOME@|$HOLER_HOME|" $SYSD_DIR/$HOLER_SERVICE
    chmod +x $HOLER_BIN/*.sh

    systemctl enable $HOLER_SERVICE
    systemctl daemon-reload
    systemctl start $HOLER_SERVICE
    systemctl status $HOLER_SERVICE
}

setup

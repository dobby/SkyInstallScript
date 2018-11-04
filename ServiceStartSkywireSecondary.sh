#!/bin/bash

cd $GOPATH/bin
nohup ./node -connect-manager -manager-address 192.168.178.101:5998 -manager-web 192.168.178.101:8000 -discovery-address discovery.skycoin.net:5999-034b1cd4ebad163e457fb805b3ba43779958bba49f2c5e1e8b062482904bacdb68 -address :5000 -web-port :6001 > /dev/null 2>&1 &
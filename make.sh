#!/bin/bash
sudo find /usr -name pi -exec rm -rf {} \;
rm -rf root/*
make clean
make DESTDIR=root PREFIX=/usr VERSION="1.0.1"
make DESTDIR=root PREFIX=/usr VERSION="1.0.1" install
cd root
sudo rsync -av ./* /
cd ..


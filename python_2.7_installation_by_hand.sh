#!/bin/bash

cd ~
mkdir tmp
cd tmp
wget http://www.python.org/ftp/python/2.7.7/Python-2.7.7.tgz
tar zxvf Python-2.7.7.tgz 
cd Python-2.7.7 
./configure --prefix=$HOME/opt/python-2.7.7
make
make install

# .bash_profile
export PATH=$HOME/opt/python-2.7.7/bin:$PATH

which python


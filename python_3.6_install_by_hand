#!/bin/bash

cd ~
mkdir tmp
cd tmp
wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tgz
tar zxvf Python-3.6.2.tgz 
cd Python-3.6.2 
./configure --prefix=$HOME/opt/python-3.6.2
make
make install

# .bash_profile
export PATH=$HOME/opt/python-3.6.2/bin:$PATH

which python3

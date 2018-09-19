#!/bin/bash

pip install virtualenv

# Creating a virtual environment using a custom Python version

cd ~
virtualenv -p /home/username/opt/python-2.7.7/bin/python my_project
source my_project/bin/activate

python -V

# deactive
deactive

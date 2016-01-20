#!/bin/bash

DIRNAME=$(pwd)
echo install into: $DIRNAME/..


apt-get install vim

git clone https://github.com/MartinTu/Panel $DIRNAME/../ledPanel

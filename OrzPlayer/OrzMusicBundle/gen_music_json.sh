#!/usr/bin/env bash
#-*- coding: utf-8 -*-
cd KeyGenMusic

JSON_FILE="music.json"
if [ -f $JSON_FILE ]; then
	echo rm $JSON_FILE
	rm $JSON_FILE
fi
tree . -J --noreport | grep -v $JSON_FILE > $JSON_FILE
echo gen new $JSON_FILE

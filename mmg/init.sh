#!/bin/sh
echo "-----------------------"
echo "Welcome to phanes v.0.1"
echo "-----------------------"
echo
default="phanesApp";
echo "[WARNING: this can only be done once, so choose wisely]"
echo -n "Choose a name for your app: ";
read appName;
grep -Rl $default . | grep -v ".git" | grep -v "angular.js" | grep -v $0 | xargs sed -i "s/$default/$appName/g";
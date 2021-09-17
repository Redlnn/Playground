#!/usr/bin/env sh
clear
echo "Pull Commit..."
git pull
echo "Update Submodule..."
git submodule update --init --recursive
# echo "Clean Cache"
# ./gradlew clean
echo "Ready to Build."
./gradlew applyPatches && ./gradlew paperclip
echo "Build Finsh!"

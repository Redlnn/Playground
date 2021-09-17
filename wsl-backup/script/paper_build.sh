#!/usr/bin/env sh
clear
echo "Pull Commit..."
git pull
echo "Update Submodule..."
git submodule update --init --recursive
# echo "Clean Cache"
# ./gradlew clean
# echo "Move Patch..."
# find ./patches/server -name '*-Fix-sand-duping.patch' -exec mv {} ./patches/removed \;
# find ./patches/server -name '*-Fix-dangerous-end-portal-logic.patch' -exec mv {} ./patches/removed \;
echo "Ready to Build."
./gradlew applyPatches && ./gradlew reobfJar
# echo "Move Patch Back..."
# find ./patches/removed -name '*-Fix-sand-duping.patch' -exec mv {} ./patches/server \;
# find ./patches/removed -name '*-Fix-dangerous-end-portal-logic.patch' -exec mv {} ./patches/server \;
# echo "Copy Server Jar"
# find ./Paper-Server/build/libs -name 'Paper-Server-reobf.jar' -exec cp {} . \;
echo "Build Finsh!"

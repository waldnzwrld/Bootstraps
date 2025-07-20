#!/bin/bash

set -e

echo "setting up es_systems.cfg"
cp /etc/emulationstation/es_systems.cfg /home/$(whoami)/.emulationstation/es_systems.cfg

echo "adding kodi to es_systems.cfg"
echo "<system>
    <fullname>Kodi</fullname>
    <name>kodi</name>
    <path>~/RetroPie/roms/kodi</path>
    <extension>.sh .SH</extension>
    <command>bash %ROM%</command>
    <platform>kodi</platform>
    <theme>kodi</theme>
  </system>" >> /home/$(whoami)/.emulationstation/es_systems.cfg

echo "creating kodi rom directory"  
mkdir /home/$(whoami)/RetroPie/roms/kodi

echo "creating kodi rom file"
echo "kodi-standalone" > /home/$(whoami)/RetroPie/roms/kodi/kodi.sh

echo "making kodi rom file executable"
chmod +x /home/$(whoami)/RetroPie/roms/kodi/kodi.sh

echo "Done"

#!/bin/bash

# Please Enter the amount of ram you want the spigot instance to use.
MAX_RAM=24G
MIN_RAM=20G

# Please enter the jar name to be run.
JAR_NAME=spigot.jar

# If you are not using Pterodactyl Panel, this lets you identify which server is which in htop.
SERVER_NAME=server





##########################################################
# END CONFIG #############################################
##########################################################
java_version_output=$(java --version 2>&1)
java_version=$(echo "$java_version_output" | awk -F '[ ".]' 'NR==1 { if ($2 == "version") print $4; else print $2 }')
echo "Detected Java $java_version"
more_than_12() {
    java -D$SERVER_NAME -Xmx$MAX_RAM -Xms$MIN_RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dterminal.jline=false -Dterminal.ansi=true -jar $JAR_NAME nogui
}
less_than_12() {
    java -D$SERVER_NAME -Xmx$MAX_RAM -Xms$MIN_RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dterminal.jline=false -Dterminal.ansi=true -jar $JAR_NAME nogui
}

start() {
  local number=$((${MAX_RAM%?}))
  local extraflags=false

  if (( number >= 12)); then
    extraflags=true
  fi

  while true; do

  if [ 12ormore ]; then
    more_than_12
  else
    less_than_12
  fi

  echo "If you want to completely stop the server process now, press Ctrl+C before the time is up!"
  echo "Rebooting in:"
  for i in 5 4 3 2 1; do
  echo "$i..."
  sleep 1
  done
  done

}

handle_java_8_to_10() {
  start
}

handle_java_11_to_21() {
  start
}

case $java_version in
  8|9|10)
    echo "Using Java 8-10 settings."
    handle_java_8_to_10
    ;;
  11|12|13|14|15|16|17|18|19|20|21)
    echo "Using Java 11+ settings."
    handle_java_11_to_21
    ;;
  *)
    echo "Java version not detected or not supported"
    read -n 1 -s -r -p "Press any key to continue..."
    exit
    ;;
esac
$AXFUN
import axeron.prop
local bin="/data/local/tmp/"
local bin_2="/data/local/tmp/fxver"
local url_engine="https://reiii3.github.io/FOXVER-AUTO/engine/core-engine.sh"
local url_prop="https://reiii3.github.io/FOXVER-AUTO/bin/prop.sh"
local url_ai="https://reiii3.github.io/FOXVER-AUTO/engine/ai-system.sh"
local url_fun="https://reiii3.github.io/Center-Module/core-system/function.sh"
local function="$bin_2/function"
local prop="$bin_2/prop"
local engine="$bin_2/engine"
local ai="$bin/ai-system"
local cek_oppo=$(echo "$tes_up" | grep -q "cmd settings put global high_performance_mode_on=1|0" && echo "$tes_up" grep -q "cmd settings put global high_performance_mode_on_when_shutdown=1|0")

if [ ! -d $bin_2 ]; then
  mkdir -p "$bin_2"
fi
sleep 1
if [ ! -f "$engine" ] && [ ! -f "$prop" ] && [ ! -f "$function" ]; then
    storm -rP "$bin_2" -s "${url_engine}" -fn "engine" "$@"
    sleep 1
    storm -rP "$bin_2" -s "${url_prop}" -fn "prop" "$@"
    sleep 1
    storm -rP "$bin_2" -s "${url_fun}" -fn "function" "$@"
fi
sleep 1

. $engine
. $prop
. $function

if [ -n "$1" ] && [ "$1" == "-g" ]; then
   pkg=$(pm list packages | grep -i "$2" | sed 's/package://g')
  axprop $engine  packageRun -s "$pkg"
  packageRun="$pkg"
  # Mengubah Package Ke Name APK
  name_g=$(pkglist -L "$packageRun")
  axprop $prop nameGame -s "$name_g"
  nameGame="$name_g"
  shift 2
fi

local war="[?]"
local in="[!]"
local pr="[-]"
local su="[✔]"

case $1 in 
    -upr | -u )
    status=$(pgrep -f ai-system)
    statuss=$(ps -fp $status)
    if [ -n "$status" ]; then
       echo "$in Reboot System.."
       sleep 0.5
       pkill -9 -f ai-system
        while pgrep -f ai-system >/dev/null; do
          echo "Menonaktifkan System AI"
          sleep 1
        done
       rm "$ai"
       echo "$su Reboot System succes "
       am broadcast -a axeron.show.TOAST --es title "REBOOT SYSTEM AI" --es msg "SYSTEM AI DOWN" --ei duration "4000" >/dev/null 2>&1
    fi
    status=$(pgrep -f ai-system)
     sleep 1
     echo
     echo "================================"
     echo "  ┌[📦] $name | UP PACKAGE" 
     echo "  └┬[📁] Package : ${packageRun:-null}"
     if [ -z $status ]; then
       echo "   └[📊] Status System : Reboot[🔄]"
     else
       echo "   └[📊] Status System : '$status'"
     fi
     echo "================================"
     echo
     sleep 2
    if [ "$status" = "$pid_ins" ]; then
      echo "$in Instalation gagal"
    else 
     echo "$pr Booting System"
      sleep 0.7
      storm -rP "$bin" -s "${url_ai}" -fn "ai-system" "$@"
      nohup sh /data/local/tmp/ai-system >/dev/null 2>&1 &
      sleep 1
      status2=$(pgrep -f ai-system)
      echo "$su Booting System succes"
      am broadcast -a axeron.show.TOAST --es title "BOOTING SYSTEM AI" --es msg "Booting Succesfuly" --ei duration "4000" >/dev/null 2>&1
    fi
     axprop $engine pid_ins -s "$status2"
     pid_ins=$status2
     sleep 1
     echo "ID AI : $pid_ins"
     exit 0
     ;;
     -info | -i )
      printer " ┌[📦] $name | INFORMATION"
      echo " ├────────────────────────────"
      printer " ├[📄] Version : $vers | $versc"
      printer " ├[🪪] ID : $AXERONID"
      printer " ├[🆕] Update : 03-15"
      printer " └┬[🎮] Game: ${nameGame:-null}"
      printer "  ├[📁] Package: ${packageRun:-null}"
      if pgrep -f ai-system >/dev/null 2>&1; then
        printer "  └[🤖] AI : Online"
      else 
        printer "  └[🤖] AI : Offline"
      fi
     exit 0
     ;;
esac
     
echo "======================================="
echo "  FOXVER AI Auto Render & Performance"
echo "======================================="
sleep 0.5
if $cek_oppo; then
  echo "$in Special Performance Supported"
else
  echo "$in Special Performance Not Supported"
fi
echo "$pr installing AI System Please wait..."
sleep 1
echo "$su succes"
sleep 1
status=$(pgrep -f ai-system)
if [ ! "$status" ]; then
    storm -rP "$bin" -s "${url_ai}" -fn "ai-system" "$@"
    nohup sh /data/local/tmp/ai-system >/dev/null 2>&1 &
    printer "$in Instalation Program Succesfuly"
fi

sleep 2
status=$(pgrep -f ai-system)
if [ -z $pid_ins ]; then
  axprop $engine pid_ins "$status"
  pid=$status
fi
if [ "$status" ]; then
    echo "${ORANGE}$su Program berhasil terpasang${END}"
    am broadcast -a axeron.show.TOAST --es title "FOXVER Instaled" --es msg "Developer : Reii" --ei duration "4000" >/dev/null 2>&1
else
    echo "$war Program failed: gagal"
fi

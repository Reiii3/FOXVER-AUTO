$AXFUN
import axeron.prop
local bin="/data/local/tmp/"
local bin_2="/data/local/tmp/fxver"
local url_engine="https://reiii3.github.io/FOXVER-AUTO/engine/core-engine.sh"
local url_prop="https://reiii3.github.io/FOXVER-AUTO/bin/prop.sh"
local url_ai="https://reiii3.github.io/FOXVER-AUTO/engine/ai-system.sh"
local url_fun="https://reiii3.github.io/Center-Module/core-system/function.sh"
local url_change="https://reiii3.github.io/FOXVER-AUTO/bin/changelogs.sh"
local url_maintenance="https://reiii3.github.io/FOXVER-AUTO/bin/maintenance.sh"
local url_main="https://reiii3.github.io/FOXVER-AUTO/engine/engine_main.sh"
local function="$bin_2/function"
local prop="$bin_2/prop"
local engine="$bin_2/engine"
local ai="$bin/ai-system"
local main="$bin_2/main"
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
storm -rP "$bin_2" -s "${url_main}" -fn "main" "$@"
sleep 1

. $main
. $engine
. $prop
. $function
maintenx
local cek_ui=$(storm "https://reiii3.github.io/FOXVER-AI/engine/user/beta_ui.txt")
local cek_beta_ui=$(echo "$cek_ui" | grep -q "$AXERONID" && echo true || echo false)
local cek_akses=$(storm "https://reiii3.github.io/FOXVER-AI/engine/user/beta_akses.txt")
local cek_beta_akses=$(echo "$cek_akses" | grep -q "$AXERONID" && echo true || echo false)

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
     -changelogs | -c )
     storm -x "$url_change" "changelogs" "$@"
     exit 0
     ;;
esac
if

if [ "$cek_beta_akses" != true ]; then
  if [ "$sys_main" = true ]; then
    storm -x "$url_maintenance" "maintenance" "$@"
    exit 0
  fi
fi


if [ $cek_beta_ui != true ]; then
  echo "======================================="
  printer "  FOXVER AI Auto Render & Performance"
  echo "======================================="
  printer "┌$in This Information In Modules exec:
  └┬$pr ax fox -i
   └$pr ax fox -info"
  printer "┌$in This Instalation In Modules Exec:
  └┬$pr ax fox -c
   └$pr ax fox -changelogs"
   printer "┌$pr This Reboot System AI In Modules exec:
  └┬$pr ax fox -u
   └$pr ax fox -upr"
  echo
  sleep 0.5
  if $cek_oppo; then
    echo "$in Special Performance Supported"
    axprop $engine perfo "true"
    perfo=true
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
else
  echo "Tess Beta UI"
fi
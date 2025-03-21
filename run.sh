$AXFUN
import axeron.prop
local bin_2="/data/local/tmp/fxver"
local url_ui_full="https://reiii3.github.io/FOXVER-AUTO/engine/sys_ui/ui_full.sh"
local url_ui_beta="https://reiii3.github.io/FOXVER-AUTO/engine/sys_ui/beta_ui.sh"
local url_engine="https://reiii3.github.io/FOXVER-AUTO/engine/core-engine.sh"
local url_prop="https://reiii3.github.io/FOXVER-AUTO/bin/prop.sh"
local url_fun="https://reiii3.github.io/Center-Module/core-system/function.sh"
local url_change="https://reiii3.github.io/FOXVER-AUTO/bin/changelogs.sh"
local url_maintenance="https://reiii3.github.io/FOXVER-AUTO/bin/maintenance.sh"
local url_main="https://reiii3.github.io/FOXVER-AUTO/engine/engine_main.sh"
local function="$bin_2/function"
local prop="$bin_2/prop"
local engine="$bin_2/engine"
local ai="$bin/ai-system"
local main="$bin_2/main"

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

case $1 in
   -dev_on )
    axprop $main dev_mode -s "true"
    dev_mode=true
    ;;
   -dev_off )
    axprop $main dev_mode -s "false"
    dev_mode=false
    ;;
esac

local cek_ui=$(storm "https://reiii3.github.io/FOXVER-AUTO/engine/user/beta_ui.txt")
local cek_beta_ui=$(echo "$cek_ui" | grep -q "$AXERONID" && echo true || echo false)
if [ $dev_mode = true ]; then
  local cek_akses=$(storm "https://reiii3.github.io/FOXVER-AUTO/engine/user/beta_akses.txt")
fi
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
      elif [ $sys_main = true ]; then
        printer "  └[🤖] AI : Maintenance"
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

if [ "$cek_beta_akses" != true ]; then
  if [ "$sys_main" = true ]; then
    storm -x "$url_maintenance" "maintenance" "$@"
    echo "Akses : $cek_beta_akses"
    exit 0
  fi
fi


if [ $cek_beta_ui != true ]; then
  storm -x "$url_ui_full" "ui_full" "$@"
  echo "UI Akses Tess"
else
  storm -x "$url_ui_beta" "beta_ui" "$@"
  echo "UI Beta Tesss"
fi
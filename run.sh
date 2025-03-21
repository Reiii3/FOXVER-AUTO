$AXFUN
import axeron.prop
local bin_2="/data/local/tmp/fxver"
local bin="/data/local/tmp"
local bin_cash="/data/local/tmp/axeron_cash/FOX"
local url_ui_full="https://reiii3.github.io/FOXVER-AUTO/engine/sys_ui/ui_full.sh"
local url_ui_beta="https://reiii3.github.io/FOXVER-AUTO/engine/sys_ui/beta_ui.sh"
local url_engine="https://reiii3.github.io/FOXVER-AUTO/engine/core-engine.sh"
local url_prop="https://reiii3.github.io/FOXVER-AUTO/bin/prop.sh"
local url_fun="https://reiii3.github.io/Center-Module/core-system/function.sh"
local url_change="https://reiii3.github.io/FOXVER-AUTO/bin/changelogs.sh"
local url_maintenance="https://reiii3.github.io/FOXVER-AUTO/bin/maintenance.sh"
local url_main="https://reiii3.github.io/FOXVER-AUTO/engine/engine_main.sh"
local url_ai_reboot="https://reiii3.github.io/FOXVER-AUTO/engine/core/reboot-ai.sh"
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
   -dev_on | -don )
    axprop $engine dev_mode -s true
    dev_mode=true
    echo "Welcome Devoloper"
    ;;
   -dev_off | -dof )
    axprop $engine dev_mode -s false
    dev_mode=false
    echo "See You Developer"
    ;;
esac
case $1 in
   -ui_realeas | -ur )
   axprop $engine ui_mod -s true
   ui_mod=true
   ;;
   ui_beta | -ut )
   axprop $engine ui_mod -s false
   ui_mod=false
   ;;
esac
if [ $ui_mod = false ]; then
  local cek_ui=$(storm "https://reiii3.github.io/FOXVER-AUTO/engine/user/beta_ui.txt")
fi
if [ $dev_mode = true ]; then
  local cek_akses=$(storm "https://reiii3.github.io/FOXVER-AUTO/engine/user/beta_akses.txt")
fi
local cek_beta_ui=$(echo "$cek_ui" | grep -q "$AXERONID" && echo true || echo false)
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
# -upr adalah fungsi untuk merestart ulang ai agar dapat menjalankan game yang baru di tambahkan
    -upr | -u )
     storm -x "$url_ai_reboot" "reboot" "$@"
     rm "$bin_cash/response"
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
     rm "$bin_cash/response"
     exit 0
     ;;
esac

if [ "$cek_beta_akses" != true ]; then
  if [ "$sys_main" = true ]; then
    storm -x "$url_maintenance" "maintenance" "$@"
    echo "Akses : $cek_beta_akses"
    rm "$bin_cash/response"
    exit 0
  fi
fi
# Main Execution Modules
if [ $cek_beta_ui != true ]; then
  storm -x "$url_ui_full" "ui_full" "$@"
  echo "UI Akses Tess"
else
  storm -x "$url_ui_beta" "beta_ui" "$@"
  echo "UI Beta Tesss"
fi
$AXFUN
import axeron.prop
local bin_2="/data/local/tmp/fxver"
local bin="/data/local/tmp"
local bin_cash="/data/local/tmp/axeron_cash"
local bin_cash_fox="/data/local/tmp/axeron_cash/FOX"
local bin_cek_update="$bin_cash/zupdate_cek"
local url_ui_full="https://reiii3.github.io/FOXVER-AUTO/engine/sys_ui/ui_full.sh"
local url_ui_beta="https://reiii3.github.io/FOXVER-AUTO/engine/sys_ui/beta_ui.sh"
local url_engine="https://reiii3.github.io/FOXVER-AUTO/engine/core-engine.sh"
local url_prop="https://reiii3.github.io/FOXVER-AUTO/bin/prop.sh"
local url_fun="https://reiii3.github.io/Center-Module/core-system/function.sh"
local url_change="https://reiii3.github.io/FOXVER-AUTO/bin/changelogs.sh"
local url_maintenance="https://reiii3.github.io/FOXVER-AUTO/bin/maintenance.sh"
local url_main="https://reiii3.github.io/FOXVER-AUTO/engine/engine_main.sh"
local url_ai_reboot="https://reiii3.github.io/FOXVER-AUTO/engine/core/reboot-ai.sh"
local url_detect="https://reiii3.github.io/Center-Module/update/fox-update.sh"
local function="$bin_2/function"
local detected="$bin/detec"
local prop="$bin_2/prop"
local engine="$bin_2/engine"
local ai="$bin/ai-system"
local main="$bin_2/main"
local cek_update="$bin_cek_update/update"

storm -rP "$bin" -s "${url_detect}" -fn "detec" "$@"
. $detected

if [ ! -d "$bin_cash/zupdate_cek" ]; then
  mkdir -p "$bin_cash/zupdate_cek"
fi
if [ ! -f $cek_update ]; then
  echo "[Don't Change It]" > "$bin_cash/zupdate_cek/update"
  axprop $cek_update update_fox -s "maintenance"
  update_fox="maintenance"
  axprop $cek_update versUpdate -s "null"
  versUpdate="null"
  axprop $cek_update verscUpdate -s "null"
  verscUpdate=null
fi
if [ -f $cek_update ]; then
  . $cek_update
fi
if [ $foxUpdate = true ]; then
  if [ -f $bin_2 ]; then
    rm -rf $bin_2
    axprop $cek_update update_fox -s "maintenance"
    update_fox="maintenance"
  fi
fi
sleep 1
if [ ! -d $bin_2 ]; then
  mkdir -p "$bin_2"
fi
sleep 1
if [ ! -f "$engine" ] && [ ! -f "$prop" ] && [ ! -f "$function" ]; then
    storm -rP "$bin_2" -s "${url_engine}" -fn "engine" "$@"
    storm -rP "$bin_2" -s "${url_prop}" -fn "prop" "$@"
    storm -rP "$bin_2" -s "${url_fun}" -fn "function" "$@"
    storm -rP "$bin_2" -s "${url_main}" -fn "main" "$@"
    sleep 1
fi

. $main
. $engine
. $prop
. $function

case $1 in
    -update )
    if [ $beta_vers != $vers ] && [ $beta_versc != $versc ]; then
    echo "updating system"
    axprop $main sys_main -s false
    sys_main=false 
    axprop $prop vers -s "$beta_vers"
    vers=$beta_vers
    axprop $prop versc -s "$beta_versc"
    versc=$beta_versc
    sleep 2
    printer "Update succesfuly"
    echo "==================="
    printer "  information New"
    echo "==================="
    printer " - version : $vers New"
    printer " - VersionCode : $versc New"
    axprop $cek_update update_fox -s "done"
    update_fox="done"
    axprop $cek_update versUpdate -s "$beta_vers"
    versUpdate="$beta_vers"
    axprop $cek_update verscUpdate -s "$beta_versc"
    verscUpdate=$beta_versc
    exit 0
    elif [ $beta_vers = $vers ] && [ $beta_versc = $versc ]; then
    echo "Modules sudah versi yang terbaru"
    exit 0
    fi
    ;;
esac
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

if [ -d $bin_cek_update ]; then
  . $cek_update
fi
if [ $update_fox = "done" ]; then
  if [ -f $cek_update ]; then
     axprop $main sys_main -s false
     sys_main=false 
     axprop $prop vers -s "$versUpdate"
     vers=$versUpdate
     axprop $prop versc -s "$verscUpdate"
     versc=$verscUpdate
  fi
fi

case $1 in
# -upr adalah fungsi untuk merestart ulang ai agar dapat menjalankan game yang baru di tambahkan
    -upr | -u )
     storm -x "$url_ai_reboot" "reboot" "$@"
     rm "$bin_cash_fox/response"
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
     rm "$bin_cash_fox/response"
     exit 0
     ;;
esac

if [ "$cek_beta_akses" != true ]; then
  if [ "$sys_main" = true ]; then
    storm -x "$url_maintenance" "maintenance" "$@"
    echo "Akses : $cek_beta_akses"
    if [ $foxUpdate = false ]; then
    echo "Waktu Update : update terbaru sudah ada"
    else
    echo "Waktu Update : Tunggu Maintenance selesaii"
    fi
    rm "$bin_cash_fox/response"
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
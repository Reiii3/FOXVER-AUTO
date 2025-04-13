$AXFUN
import axeron.prop
local bin_2="/data/local/tmp/fxver"
local bin="/data/local/tmp"
local bin_cash="/data/local/tmp/axeron_cash"
local bin_cash_fox="/data/local/tmp/axeron_cash/FOX"
local bin_cek_update="$bin_cash/zupdate_cek"
local bin_dev="$bin/debug/control"
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
local war="[?]"
local in="[!]"
local pr="[-]"
local su="[√]"  
local time=$(date "+%a %b %d %H:%M %Z %Y")
# == Pemisah skrip dengan kode program == #
#================================================================================#

if [ -d $bin_dev ]; then
  . $bin_dev
fi

case $1 in
   -debugon | -duon)
   axprop $bin_dev debug -s true
   debug=true
   ;;
   -debugoff | -duoff)
   axprop $bin_dev debug -s false
   debug=false
   ;;
esac

storm -rP "$bin" -s "${url_detect}" -fn "detec" "$@"
. $detected
if [[ $debug = true ]]; then
  echo "DEBUG : foxUpdate before : $foxUpdate"
fi

if [ ! -d "$bin_cash/zupdate_cek" ]; then
   mkdir -p "$bin_cash/zupdate_cek"
fi

if [[ ! -f $cek_update ]]; then
  echo "# Dont Change It" > "$bin_cash/zupdate_cek/update"
  sleep 2
  axprop $cek_update update_fox -s "maintenance"
  update_fox="maintenance"
  axprop $cek_update versUpdate -s "null"
  versUpdate="null"
  axprop $cek_update verscUpdate -s null
  verscUpdate=null
  axprop $cek_update waktuUp -s null
  waktuUp=null
  axprop $cek_update waktuIn -s null
  waktuIn=null
  axprop $cek_update notif -s false
  notif=false
fi

if [[ -f $cek_update ]]; then
  . $cek_update
  if [[ $debug = true ]]; then
  echo "DEBUG cek_update di temukan, mencari data..."
  fi
else
  if [[ $debug = true ]]; then
    echo "ERROR cek_update dont not detected."
  fi
fi

#=============================#
# === Menghapus file lama === #
#=============================#
# // Fungsi ini di gunakan untuk mendeteksi update atau juga bisa di sebut core dari system update
if [[ "$foxUpdate" == "true" ]]; then
    rm -rf $bin_2
  if [[ $debug = true ]]; then
    echo "bin 2 removed"
  fi
    axprop $cek_update update_fox -s "maintenance"
    update_fox="maintenance"
    axprop $cek_update notif -s false
    update_fox=false
    axprop $cek_update waktuUp -s "$time"
    waktuUp="$time"
    if [[ $debug = true ]]; then
      echo "Tes Pengapdetan"
    fi
else
  if [[ $debug = true ]]; then
   echo "keslahan : $foxUpdate"
  fi
fi

if [[ $debug = true ]]; then
  echo "detected main : $update_fox"
  echo "DEBUG: foxUpdate='$foxUpdate'"
  echo "DEBUG (length): ${#foxUpdate}"
  sleep 1
fi

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
  if [[ $debug = true ]]; then
    echo "all file dev ter ekstrak"
  fi
fi

. $main
. $engine
. $prop
. $function
  
# // Ini untuk mengupdate version modules
case $1 in
    -update )
    if [ $foxUpdate = false ]; then
      if [ $beta_vers != $vers ] && [ $beta_versc != $versc ]; then
        echo "updating system"
        axprop $main sys_main -s false
        sys_main=false 
        axprop $prop vers -s "$beta_vers"
        vers=$beta_vers
        axprop $prop versc -s "$beta_versc"
        versc=$beta_versc
        axprop $cek_update waktuIn -s "$time"
        waktuIn="$time"
        sleep 2
        printer "Update succesfuly"
        echo "==================="
        printer "  information New"
        echo "==================="
        printer " - version : $vers New"
        printer " - VersionCode : $versc New"
        printer " - update Pada : $waktuIn"
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
    else 
     echo
     echo "Tunggu maintenance selesai, silahkan pantau perkembangan"
     echo
     exit 0
    fi
    ;;
esac
# // ini untuk mode developer
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

# // Ini di gunakan untuk developer atau donatur yang menggunakan beta version
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


. $cek_update

# Ini Adalah pengecekan apakah dia sudah update atau belum agar system maintenance di ubah ke mode off
if [ $update_fox = "done" ]; then
     axprop $main sys_main -s false
     sys_main=false 
     axprop $prop vers -s "$versUpdate"
     vers=$versUpdate
     axprop $prop versc -s "$verscUpdate"
     versc=$verscUpdate
  if [ $notif = false ]; then
    echo "[System telah di update ke versi $vers | $versc]"
    axprop $cek_update notif -s true
    update_fox=true
  fi
fi

# Ini untuk Mengecek Apakah dia baru menginstal module ini agar langsung dapat menggunakan version terbaru
if [[ $versUpdate = "null" ]] && [[ $verscUpdate = "null" ]]; then
echo
echo "    [initializing system]"
  if [[ $foxUpdate != true ]]; then
    if [[ $sys_main = true ]]; then
      axprop $cek_update update_fox -s "done"
      update_fox="done"
      axprop $cek_update versUpdate -s "$beta_vers"
      versUpdate="$beta_vers"
      axprop $cek_update verscUpdate -s "$beta_versc"
      verscUpdate=$beta_versc
      axprop $main sys_main -s false
      sys_main=false
    
    echo "- information Version -"
    echo " version     : $versUpdate"
    echo " versionCode : $verscUpdate"
    echo " decription  : $descript"
    echo
       axprop $prop vers -s "$versUpdate"
       vers=$versUpdate
       axprop $prop versc -s $verscUpdate
       versc=$verscUpdate
       axprop $cek_update waktuIn -s $time
       waktuIn=$time
    exit 0
    fi
  else
    echo
      echo "system masih dalam masa pemeliharaan jadi silahkan tunggu sampai selesai"
      printer "   - Terima kasih -"
      axprop $cek_update versUpdate -s "$vers"
      versUpdate="$vers"
      axprop $cek_update verscUpdate -s $versc
      verscUpdate=$versc
    if [[ $debug = true ]]; then
      echo "detected main : $update_fox"
    fi
  fi
echo
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
      printer " ├[📄] Version : ${vers:-null} | ${versc:-null}"
      printer " ├[🪪] ID : $AXERONID"
      printer " ├[🆕] New update : $waktuIn"
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
    echo "Waktu Update : tunggu maintenance selesaii"
    fi
    rm "$bin_cash_fox/response"
    echo
    exit 0
  fi
fi
# Main Execution Modules
if [ $cek_beta_ui != true ]; then
  if [[ $debug = true ]]; then
    echo "akses : $update_fox uodate fox"
    echo "akses : $foxUpdate fox update"
  fi
  storm -x "$url_ui_full" "ui_full" "$@"
  echo "UI Akses Tess"
else
  storm -x "$url_ui_beta" "beta_ui" "$@"
  echo "UI Beta Tesss"
fi
$AXFUN
import axeron.prop
bin="/data/local/tmp/"
bin_2="/data/local/tmp/fxver"
url_engine="https://reiii3.github.io/FOXVER-AUTO/engine/core-engine.sh"
url_prop="https://reiii3.github.io/FOXVER-AUTO/bin/prop.sh"
url_ai="https://reiii3.github.io/FOXVER-AUTO/engine/ai-system.sh"
prop="$bin_2/prop"
engine="$bin_2/engine"
ai="$bin/ai-system"
if [ ! -f $engine ] && [ ! -f $prop ]; then
    storm -rP "$bin" -s "${url_engine}" -fn "engine" "$@"
    sleep 1
    storm -rP "$bin" -s "${url_prop}" -fn "prop" "$@"
fi

. $engine
. $prop

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
    status=$(pgrep -f ai_tes)
    statuss=$(ps -fp $status)
    if [ -n "$status" ]; then
       echo "Reboot System.."
       sleep 0.5
       pkill -9 -f ai_tes
        while pgrep -f ai_tes >/dev/null; do
          echo "Menonaktifkan System AI"
          sleep 1
         done
       rm "$ai"
       rm -rf "$path_cash"
       echo "Reboot System succes "
       am broadcast -a axeron.show.TOAST --es title "REBOOT SYSTEM AI" --es msg "SYSTEM AI DOWN" --ei duration "4000" >/dev/null 2>&1
    fi
    status=$(pgrep -f ai_tes)
     sleep 1
     echo
     echo "================================"
     echo "  ┌[📦] $name | UP PACKAGE" 
     echo "  └┬[📁] Package : $packageRun"
     if [ -z $status ]; then
       echo "   └[📊] Status System : Reboot[🔄]"
     else
       echo "   └[📊] Status System : '$status'"
     fi
     echo "================================"
     echo
     sleep 2
    if [ "$status" = "$pid_ins" ]; then
      echo "Instalation gagal"
    else 
     echo "Booting System"
      sleep 0.7
      storm -rP "$bin" -s "${url_AI}" -fn "ai_tes" "$@"
      nohup sh /data/local/tmp/ai_tes >/dev/null 2>&1 &
      sleep 1
      status2=$(pgrep -f ai_tes)
      echo "Booting System succes AI Active"
      am broadcast -a axeron.show.TOAST --es title "BOOTING SYSTEM AI" --es msg "Booting Succesfuly" --ei duration "4000" >/dev/null 2>&1
    fi
     axprop $engine pid_ins -s "$status2"
     pid_ins=$status2
     sleep 1
     echo "ID AI : $pid_ins"
     exit 0
     ;;
     -info | -i )
      echo " ┌[📦] $name | INFORMATION"
      echo " ├────────────────────────────"
      echo " ├[📄] Version : $version | $verc"
      echo " ├[🪪] ID : $AXERONID"
      echo " ├[🆕] Update : 03-15"
      echo " └┬[🎮] Game: $nameGame"
      echo "  └[📁] Package: $packageRun"
     exit 0
     ;;
esac
     
echo "======================================"
echo "    Tes AI Auto Render & Performance"
echo "======================================"
sleep 0.5
echo "installing AI Please wait..."
sleep 1
echo "succes"
sleep 1
status=$(pgrep -f ai_tes)
if [ ! "$status" ]; then
    storm -rP "$bin" -s "${url_ai}" -fn "ai-system" "$@"
    nohup sh /data/local/tmp/ai_tes >/dev/null 2>&1 &
    echo "Program diinstall"
    
fi

sleep 2
status=$(pgrep -f ai_tes)
axprop $engine pid_ins "$status"
pid=$status
if [ "$status" ]; then
    echo "${ORANGE}Program berhasil terpasang${END}"
    am broadcast -a axeron.show.TOAST --es title "AI TESss" --es msg "Developer : henpeex vBETA" --ei duration "4000" >/dev/null 2>&1
else
    echo "Program failed: gagal"
fi

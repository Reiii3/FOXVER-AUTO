$AXFUN
import axeron.prop
local bin_2="/data/local/tmp/fxver"
local function="$bin_2/function"
local prop="$bin_2/prop"
local engine="$bin_2/engine"
local cek_oppo=$(echo "$tes_up" | grep -q "cmd settings put global high_performance_mode_on=1|0" && echo "$tes_up" grep -q "cmd settings put global high_performance_mode_on_when_shutdown=1|0")

local war="[?]"
local in="[!]"
local pr="[-]"
local su="[√]"  

. $prop
. $engine
. $function

echo "======================================="
printer "  FOXVER AI Auto Render & Performance"
printer "              [Beta]"
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

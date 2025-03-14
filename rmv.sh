$AXFUN
import axeron.prop
bin="/data/local/tmp/fxver"
path="/data/locla/tmp/axeron_cash/FOX"
prop="$bin/prop"
function="$bin/function"

. $prop
. $function

echo "=========================="
printer "  $name | AI REMOVED"
echo "=========================="
sleep 1
echo "  ┌[📦] Remove Modules System"
echo "  ├[🖲] Game : $nameGame"
echo "  └┬[📄] Version : $vers | $versc"
echo "   └[⚠️] Status System : Removed "
echo "  ©️Copyright By Reii"
sleep 1
pkill -f "/data/local/tmp/ai-system"
rm -rf "$bin"
rm -rf "$path"
rm "/data/local/tmp/ai-system"
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
     echo " ┌[📦] $name | UP PACKAGE" 
     echo " └┬[📁] Package : ${packageRun:-null}"
     if [ -z $status ]; then
       echo "  └[📊] Status System : Reboot[🔄]"
     else
       echo "  └[📊] Status System : '$status'"
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

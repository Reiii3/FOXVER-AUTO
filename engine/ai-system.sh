$AXFUN
import axeron.prop
IDLE_TIME=5
bin="/data/local/tmp/fxver"
engine="$bin/engine"
prop="$bin/prop"
gamerun=""
notif_run=""

. $engine
. $prop

ai_start() {
    setprop debug.hwui.renderer skiavk
    setprop debug.hwui.shadow.renderer skiavk
    cmd thermalservice override-status 0
    sleep 0.5
}

ai_op() {
  cmd settings put system high_performance_mode_on 0
  sleep 0.5
  cmd settings put system high_performance_mode_on 1
  cmd settings put system high_performance_mode_on_when_shutdown 1
}

ai_op_r() {
  cmd settings put system high_performance_mode_on 0
  cmd settings put system high_performance_mode_on_when_shutdown 0
}

ai_end() {
    setprop debug.hwui.renderer opengl
    setprop debug.hwui.shadow.renderer opengl
    cmd thermalservice override-status 1
    sleep 1
}

cmd notification post -S bigtext -t "AI FOXVER" "tag" "ACTIVED AI FOXVER | Developer : ReiiEja"
sleep 1
check_game() {
detected_apps=$(dumpsys window | grep -E 'mCurrentFocus|mFocusedApp' | grep -o "$packageRun")
render_detected=$(getprop debug.hwui.renderer)
perfo=$(echo "$tes_up" | grep -q "cmd settings put global high_performance_mode_on=1|0" && echo "$tes_up" grep -q "cmd settings put global high_performance_mode_on_when_shutdown=1|0")
    if [ -n "$detected_apps" ]; then
        if [ "$gamerun" != "running" ] || [ "$render_detected" != "skiavk" ]; then
            ai_start
            if $perfo; then
              ai_op
            fi
            gamerun="running"
        fi
        if [ "$notif_run" != "run" ]; then
            cmd notification post -S bigtext -t "FOXVER AI" "game_log" "AI GAME RUNNING : $nameGame | Actived Performance"
            am broadcast -a gvr.service.TOAST --es title "FOXVER AI" --es message "Performance Actived" --ei duration "3000"
            notif_run="run"
        fi
        echo
        echo "Game sedang dimainkan: $detected_apps"
        echo "Render saat berada di dalam game: $(getprop debug.hwui.renderer)"
        echo "Status sekarang adalah : $gamerun"
        echo
        IDLE_TIME=3
    else
        if [ "$gamerun" != "stopped" ] || [ "$render_detected" != "opengl" ]; then
            ai_end
            if $perfo; then
              ai_op_r
            fi
            gamerun="stopped"
        fi

        if [ "$notif_run" != "stop" ]; then
            cmd notification post -S bigtext -t "FOXVER AI" "game_log" "AI GAME CLOSED | Deactived Performance"
            am broadcast -a gvr.service.TOAST --es title "FOXVER AI" --es message "Performance Deactived" --ei duration "3000"
            notif_run="stop"
        fi
        echo
        echo "Tidak ada game yang berjalan"
        echo "Render saat berada di luar game: $(getprop debug.hwui.renderer)"
        echo "Status sekarang adalah : $gamerun"
        echo
        IDLE_TIME=5
    fi
}

while true; do
    echo 
    echo "Loop berhasil dijalankan"
    check_game
    echo "Loop akan berulang setiap ${IDLE_TIME} detik"
    echo "status noti : $notif_run"
    echo "status game : $gamerun"
    echo
    sleep "$IDLE_TIME"
done

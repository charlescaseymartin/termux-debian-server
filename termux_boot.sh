#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock

# Start server
server_processes="-- /usr/local/bin/server-up"
pd_command="pd sh webserver --user sonny --isolated --no-kill-on-exit $server_processes"
nohup $pd_command >/dev/null 2>&1 &


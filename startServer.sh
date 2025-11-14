#!/bin/bash -x

PORT=80

# Make sure the port is free and start the application
PID=$(lsof -t -wni tcp:${PORT})
[ ! -z ${PID} ] && kill -9 ${PID}
rm -f tmp/pids/server.pid

sudo -b --preserve-env=PATH env nohup rails server --binding 0.0.0.0 --port ${PORT}

exit

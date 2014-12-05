#!/bin/sh
# /etc/init.d/hubot

### BEGIN INIT INFO
# Provides:          hubot
# Required-Start:    $remote_fs $syslog $time $network
# Required-Stop:     $remote_fs $syslog $time $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts the Eveoh Hubot daemon
# Description:       This file is used to start the Eveoh Hubot daemon and should be placed in /etc/init.d
### END INIT INFO

# BASED ON:
# Author:   Sheldon Neilson <sheldon[AT]neilson.co.za>
# Url:      http://www.neilson.co.za/creating-a-java-daemon-system-service-for-debian-using-apache-commons-jsvc/
# Date:     25/04/2013
#
# AND
#
# Author:     Tomas Varaneckas <tomas.varaneckas@gmail.com>
# Url:        https://github.com/spajus/hubot-example/blob/master/misc/hubot.init.d.debian.sh

NAME="hubot"
DESC="Eveoh Hubot daemon"

HUBOT_PATH=/home/hubot
BOT_PATH=$HUBOT_PATH/eveohbot
DAEMON=bin/$NAME

PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:$BOT_PATH/node_modules:$BOT_PATH/node_modules/hubot/node_modules:$HUBOT_PATH/local/bin

# The user to run the daemon as.
USER="hubot"
GROUP="hubot"

# The file that will contain our process identification number (pid) for other scripts/programs that need to access it.
PIDFILE="/var/run/$NAME.pid"
LOGFILE="$BOT_PATH/logs/$NAME.log"

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

. /lib/lsb/init-functions

hubot_start()
{
    status="0"

    pidofproc -p $PIDFILE node >/dev/null || status="$?"
    [ "$status" = 0 ] && return 2;

    touch $PIDFILE && chown $USER:$GROUP $PIDFILE

    start-stop-daemon --no-close --user $USER --quiet --start --pidfile $PIDFILE -c $USER:$GROUP --make-pidfile --background --chdir $BOT_PATH --exec $DAEMON >> $LOGFILE 2>&1 || return 2
}

hubot_stop()
{
    status="0"

    pidofproc -p $PIDFILE node >/dev/null || status="$?"
    [ "$status" = 3 ] && return 1

    start-stop-daemon --stop --quiet --pidfile $PIDFILE

    RETVAL="$?"
    [ "$RETVAL" = 2 ] && return 2

    rm -f $PIDFILE
    
    return "$RETVAL"
}

case "$1" in
    start)
        log_daemon_msg "Starting $DESC" "$NAME"
        
        hubot_start
        
        case "$?" in
            0|1) log_end_msg 0 ;;
            2) log_end_msg 1 ;;
        esac
    ;;
    stop)
        echo "Stopping $DESC..."
        log_daemon_msg "Stopping $DESC" "$NAME"
        
        hubot_stop
        
        case "$?" in
            0|1) log_end_msg 0 ;;
            2) log_end_msg 1 ;;
        esac
    ;;
    status)
        status_of_proc -p $PIDFILE node $NAME && exit 0 || exit $?
    ;;
    restart)
        log_daemon_msg "Restarting $DESC" "$NAME"

        hubot_stop

        case "$?" in
            0|1)
                hubot_start # Daemon not running / stopped
            case "$?" in
                0) log_end_msg 0 ;;
                1) log_end_msg 1 ;; # Old process is still running
                *) log_end_msg 1 ;; # Failed to start
            esac
            ;;
        *)
        
        # Failed to stop
        log_end_msg 1
        ;;
    esac
    ;;
    *)
        echo "Usage: /etc/init.d/$NAME {start|stop|restart}" >&2
        exit 3
    ;;
esac

:
#!/bin/bash
source /etc/apache2/envvars

if [ -f /var/run/apache2/apache2.pid ]; then
    apachePid=$(cat /var/run/apache2/apache2.pid)
    echo "Found file 'apache2.pid' with pid $apachePid. Let's check if there is a process belonging to it!"
    processName=$(ps -p $apachePid -o comm)

    if [ "$processName" != "apache2" ] && [ "$processName" != "/usr/sbin/apache2 -D FOREGROUND" ]; then
        echo "The found apache.pid is not belonging to an apache-process. I'm going to remove the pid-file."
        rm -f /var/run/apache2/apache2.pid
        echo "Removing of pid-file was successfull."

        echo "For cleaning-reasons I'm also killing all apache-processes."
        killall -9 apache2
        echo "Now this is a safe place again. Enjoy."
      else
        echo "The pid-file is belonging to an apache-process, so it will stay alive."
    fi
fi

exec /usr/sbin/apache2 -D FOREGROUND

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
export CATALINA_HOME="/c/Program Files/apache-tomcat-9.0.113"
export CATALINA_BASE="$ROOT/tomcat-base"

mkdir -p "$CATALINA_BASE"/{webapps,logs,work,temp,conf}

if [[ ! -f "$CATALINA_BASE/conf/server.xml" ]]; then
  cp "$CATALINA_HOME/conf/"*.xml "$CATALINA_BASE/conf/"
  cp "$CATALINA_HOME/conf/"*.properties "$CATALINA_BASE/conf/"
  cp "$CATALINA_HOME/conf/"*.policy "$CATALINA_BASE/conf/"
fi

bash "$ROOT/build.sh"
cp "$ROOT/HospitalManagementApp.war" "$CATALINA_BASE/webapps/"

case "${1:-start}" in
  start)
    "$CATALINA_HOME/bin/startup.bat"
    echo "App URL: http://localhost:8080/HospitalManagementApp/"
    ;;
  stop)
    "$CATALINA_HOME/bin/shutdown.bat"
    ;;
  restart)
    "$CATALINA_HOME/bin/shutdown.bat" || true
    sleep 3
    "$CATALINA_HOME/bin/startup.bat"
    echo "App URL: http://localhost:8080/HospitalManagementApp/"
    ;;
  *)
    echo "Usage: $0 [start|stop|restart]"
    exit 1
    ;;
esac

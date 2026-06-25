#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/HospitalManagementApp/src/main/java"
WEBAPP="$ROOT/HospitalManagementApp/src/main/webapp"
CLASSES="$WEBAPP/WEB-INF/classes"
LIB="$WEBAPP/WEB-INF/lib"
TOMCAT_LIB="/c/Program Files/apache-tomcat-9.0.113/lib"
JDK="/c/Java/jdk-17"
SERVLET_API="$LIB/servlet-api.jar"
MYSQL_JAR=$(ls "$LIB"/mysql-connector-j-*.jar 2>/dev/null | head -1)

if [[ ! -f "$TOMCAT_LIB/servlet-api.jar" ]]; then
  echo "Tomcat servlet-api.jar not found at: $TOMCAT_LIB/servlet-api.jar"
  exit 1
fi

if [[ -z "$MYSQL_JAR" ]]; then
  echo "MySQL connector JAR not found in $LIB"
  exit 1
fi

cp "$TOMCAT_LIB/servlet-api.jar" "$SERVLET_API"

echo "Compiling Java sources..."
mkdir -p "$CLASSES"
cd "$ROOT"
REL_SERVLET="HospitalManagementApp/src/main/webapp/WEB-INF/lib/servlet-api.jar"
REL_MYSQL=$(ls HospitalManagementApp/src/main/webapp/WEB-INF/lib/mysql-connector-j-*.jar | head -1)
mapfile -t JAVA_FILES < <(find "$SRC" -name "*.java" | sort)
"$JDK/bin/javac.exe" -encoding UTF-8 \
  -cp "${REL_SERVLET};${REL_MYSQL}" \
  -d "HospitalManagementApp/src/main/webapp/WEB-INF/classes" \
  "${JAVA_FILES[@]}"

echo "Building WAR file..."
rm -f "$ROOT/HospitalManagementApp.war"
STAGING="$ROOT/build/war-staging"
rm -rf "$STAGING"
mkdir -p "$STAGING"
cp -r "$WEBAPP/." "$STAGING/"
rm -f "$STAGING/WEB-INF/lib/servlet-api.jar"

"$JDK/bin/jar.exe" cvf "$ROOT/HospitalManagementApp.war" -C "$STAGING" .
rm -rf "$STAGING"

echo "Build complete: $ROOT/HospitalManagementApp.war"

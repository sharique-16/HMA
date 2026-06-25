# Quick Start: Deploy from VS Code

## ✅ Java is Already Installed!

Your system has Java 17 installed at `C:\Java\jdk-17`. The configuration files are ready!

## Step-by-Step Deployment

### 1. Fix Java Configuration in VS Code

The error you saw (`bash: Java:: command not found`) happens when you type commands in the terminal. Use the Command Palette instead:

1. Press `Ctrl+Shift+P` (Command Palette)
2. Type: `Java: Configure Java Runtime`
3. Select your JDK (should auto-detect `C:\Java\jdk-17`)

**OR** manually set in settings:
- Press `Ctrl+,` to open Settings
- Search: `java.configuration.runtimes`
- Add: `C:\Java\jdk-17`

### 2. Install Required Extensions

Press `Ctrl+Shift+X` and install:

1. **Extension Pack for Java** (`vscjava.vscode-java-pack`)
2. **Tomcat for Java** (`adashen.vscode-tomcat`)
3. **MySQL** (`cweijan.vscode-mysql-client2`)

### 3. Setup Database

1. Make sure MySQL is running
2. Open terminal in VS Code (`Ctrl+``)
3. Run:
   ```bash
   mysql -u root -p < database_setup.sql
   ```
   (Enter your MySQL password when prompted)

### 4. Add MySQL JDBC Driver

1. Download: https://dev.mysql.com/downloads/connector/j/
2. Extract `mysql-connector-java-8.0.x.jar`
3. Copy to: `HospitalManagementApp/src/main/webapp/WEB-INF/lib/`

### 5. Build WAR File

**Easy way:**
- Press `Ctrl+Shift+B`
- Select "Build WAR File"
- Wait for "Build WAR File" task to complete

**Or use terminal:**
```bash
cd HospitalManagementApp/src/main/webapp
jar cvf ../../../HospitalManagementApp.war *
```

### 6. Deploy to Tomcat

**Option A: Using Tomcat Extension (Recommended)**

1. Press `Ctrl+Shift+P`
2. Type: `Tomcat: Add Tomcat Server`
3. Browse to your Tomcat folder (e.g., `C:\Program Files\Apache Tomcat\apache-tomcat-9.0.xx`)
4. Right-click `HospitalManagementApp.war` in Explorer
5. Select: `Run on Tomcat Server`

**Option B: Manual Copy**

1. Copy `HospitalManagementApp.war` to Tomcat's `webapps/` folder
2. Start Tomcat:
   ```bash
   bash run.sh
   ```

   Or manually (Tomcat is at `C:\Program Files\apache-tomcat-9.0.113`):
   ```bash
   export CATALINA_HOME="/c/Program Files/apache-tomcat-9.0.113"
   export CATALINA_BASE="$(pwd)/tomcat-base"
   bash build.sh
   cp HospitalManagementApp.war tomcat-base/webapps/
   "$CATALINA_HOME/bin/startup.bat"
   ```

### 7. Access Your App

Open browser: `http://localhost:8080/HospitalManagementApp/`

---

## Common Issues & Fixes

### ❌ "Java: Warning" in status bar
**Fix:** 
- Install "Extension Pack for Java"
- Restart VS Code
- Press `Ctrl+Shift+P` → `Java: Clean Java Language Server Workspace`

### ❌ Build fails with "jar: command not found"
**Fix:** Java is installed but `jar` might not be in PATH. Use full path:
```bash
"C:\Java\jdk-17\bin\jar.exe" cvf HospitalManagementApp.war -C HospitalManagementApp/src/main/webapp .
```

### ❌ Database connection fails
**Fix:** 
- Check MySQL is running: `net start MySQL80` (Windows)
- Edit `HospitalManagementApp/src/main/webapp/WEB-INF/classes/db.properties` and set your MySQL username/password
- Run the setup script: `mysql -u root -p < database_setup.sql`
- Test connection: `mysql -u root -p`

---

## Quick Commands Reference

| Action | Shortcut/Command |
|--------|------------------|
| Build WAR | `Ctrl+Shift+B` |
| Command Palette | `Ctrl+Shift+P` |
| Open Terminal | `Ctrl+`` (backtick) |
| Open Settings | `Ctrl+,` |
| Java: Configure Runtime | `Ctrl+Shift+P` → type "Java: Configure Java Runtime" |

---

## What's Already Configured

✅ `.vscode/tasks.json` - Build tasks ready
✅ `.vscode/settings.json` - Java paths configured
✅ `.vscode/launch.json` - Debug configuration ready

Just install extensions and you're good to go! 🚀



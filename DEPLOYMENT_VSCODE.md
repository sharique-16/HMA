# Deploying Hospital Management App from VS Code

This guide covers deploying your Java web application directly from Visual Studio Code.

## Prerequisites

### 1. Install Required Software

- **Java JDK 11+** - Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://adoptium.net/)
- **Apache Tomcat 9.x or 10.x** - Download from [Apache Tomcat](https://tomcat.apache.org/)
- **MySQL Server** - Download from [MySQL](https://dev.mysql.com/downloads/)
- **VS Code** - Latest version from [code.visualstudio.com](https://code.visualstudio.com/)

### 2. Install VS Code Extensions

Open VS Code and install these essential extensions:

1. **Extension Pack for Java** (by Microsoft)
   - Includes: Language Support, Debugger, Test Runner, Maven, Project Manager
   - Search: `vscjava.vscode-java-pack`

2. **Tomcat for Java** (by Wei Shen)
   - Enables Tomcat server management in VS Code
   - Search: `adashen.vscode-tomcat`

3. **MySQL** (by Jun Han)
   - For database management
   - Search: `cweijan.vscode-mysql-client2`

4. **Java Extension Pack** (if not already installed)
   - Search: `vscjava.vscode-java-pack`

**Quick Install:**
- Press `Ctrl+Shift+X` (or `Cmd+Shift+X` on Mac) to open Extensions
- Search and install each extension above

---

## Step 1: Setup Project in VS Code

### 1.1 Open Project in VS Code

```bash
# Open the project folder in VS Code
code "C:\Users\sharique ahmed\OneDrive\Desktop\hma"
```

Or:
- Open VS Code
- File → Open Folder → Select `hma` folder

### 1.2 Configure Java Settings

VS Code should automatically detect Java. Verify:

1. Press `Ctrl+Shift+P` (Command Palette)
2. Type: `Java: Configure Java Runtime`
3. Select your JDK installation

### 1.3 Add MySQL JDBC Driver

1. Download MySQL Connector/J from [MySQL Downloads](https://dev.mysql.com/downloads/connector/j/)
2. Extract `mysql-connector-java-8.0.x.jar`
3. Copy it to: `HospitalManagementApp/src/main/webapp/WEB-INF/lib/`

---

## Step 2: Setup Database

### 2.1 Using VS Code MySQL Extension

1. Open MySQL extension (click MySQL icon in sidebar)
2. Click "Add Connection"
3. Enter:
   - Host: `localhost`
   - Port: `3306`
   - User: `root`
   - Password: `root` (or your MySQL password)
   - Database: `hospital`

### 2.2 Create Database Schema

1. Right-click on the connection → "New Query"
2. Copy and paste the contents of `database_setup.sql`
3. Execute the query (click Run or press `F5`)

Or use terminal:
```bash
mysql -u root -p < database_setup.sql
```

---

## Step 3: Build the Application

### Option A: Using VS Code Tasks (Recommended)

Create a build task for VS Code:

1. Create `.vscode` folder in project root (if it doesn't exist)
2. Create `tasks.json` file:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build WAR File",
            "type": "shell",
            "command": "jar",
            "args": [
                "cvf",
                "${workspaceFolder}/HospitalManagementApp.war",
                "-C",
                "${workspaceFolder}/HospitalManagementApp/src/main/webapp",
                "."
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": []
        },
        {
            "label": "Compile Java",
            "type": "shell",
            "command": "javac",
            "args": [
                "-cp",
                "${workspaceFolder}/HospitalManagementApp/src/main/webapp/WEB-INF/lib/*:${env:TOMCAT_HOME}/lib/servlet-api.jar",
                "-d",
                "${workspaceFolder}/HospitalManagementApp/src/main/webapp/WEB-INF/classes",
                "${workspaceFolder}/HospitalManagementApp/src/main/java/**/*.java"
            ],
            "group": "build",
            "problemMatcher": []
        }
    ]
}
```

**To build:**
- Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on Mac)
- Select "Build WAR File"

### Option B: Using Terminal in VS Code

1. Open integrated terminal: `Ctrl+`` (backtick) or Terminal → New Terminal
2. Run build commands:

```bash
# Navigate to project
cd HospitalManagementApp

# Compile Java files (if needed)
javac -cp "src/main/webapp/WEB-INF/lib/*" -d src/main/webapp/WEB-INF/classes src/main/java/**/*.java

# Create WAR file
cd src/main/webapp
jar cvf ../../../../HospitalManagementApp.war *
```

### Option C: Using Maven (if you add pom.xml)

If you create a `pom.xml` file, you can use Maven:

```bash
# In VS Code terminal
cd HospitalManagementApp
mvn clean package
```

---

## Step 4: Deploy to Tomcat

### Method 1: Using Tomcat Extension (Easiest)

1. **Configure Tomcat Server:**
   - Press `Ctrl+Shift+P`
   - Type: `Tomcat: Add Tomcat Server`
   - Select your Tomcat installation directory
   - Example: `C:\Program Files\Apache Tomcat\apache-tomcat-9.0.xx`

2. **Deploy WAR File:**
   - Right-click on `HospitalManagementApp.war` in Explorer
   - Select: `Run on Tomcat Server`
   - Or use Command Palette: `Tomcat: Run on Tomcat Server`

3. **Start Tomcat:**
   - Click Tomcat icon in sidebar
   - Right-click on your server → `Start`
   - Or use Command Palette: `Tomcat: Start`

4. **Access Application:**
   - Open browser: `http://localhost:8080/HospitalManagementApp/`

### Method 2: Manual Deployment via Tasks

Add deployment task to `tasks.json`:

```json
{
    "label": "Deploy to Tomcat",
    "type": "shell",
    "command": "${config:tomcat.path}/bin/catalina.bat",
    "args": ["start"],
    "windows": {
        "command": "${config:tomcat.path}/bin/catalina.bat"
    },
    "linux": {
        "command": "${config:tomcat.path}/bin/catalina.sh"
    },
    "group": "build",
    "dependsOn": "Build WAR File"
}
```

Add to `settings.json`:
```json
{
    "tomcat.path": "C:/Program Files/Apache Tomcat/apache-tomcat-9.0.xx"
}
```

### Method 3: Copy WAR to Tomcat

Add this task to `tasks.json`:

```json
{
    "label": "Copy WAR to Tomcat",
    "type": "shell",
    "command": "copy",
    "args": [
        "${workspaceFolder}/HospitalManagementApp.war",
        "${config:tomcat.path}/webapps/"
    ],
    "windows": {
        "command": "copy"
    },
    "linux": {
        "command": "cp"
    },
    "group": "build",
    "dependsOn": "Build WAR File"
}
```

---

## Step 5: VS Code Configuration Files

### Complete `.vscode/tasks.json`

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build WAR File",
            "type": "shell",
            "command": "jar",
            "args": [
                "cvf",
                "${workspaceFolder}/HospitalManagementApp.war",
                "-C",
                "${workspaceFolder}/HospitalManagementApp/src/main/webapp",
                "."
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": []
        },
        {
            "label": "Deploy to Tomcat",
            "type": "shell",
            "command": "${input:tomcatPath}/bin/catalina.bat",
            "args": ["start"],
            "windows": {
                "command": "${input:tomcatPath}/bin/catalina.bat"
            },
            "linux": {
                "command": "${input:tomcatPath}/bin/catalina.sh"
            },
            "group": "build",
            "dependsOn": "Build WAR File"
        }
    ],
    "inputs": [
        {
            "id": "tomcatPath",
            "type": "promptString",
            "description": "Enter Tomcat installation path"
        }
    ]
}
```

### `.vscode/settings.json`

```json
{
    "java.configuration.updateBuildConfiguration": "automatic",
    "java.compile.nullAnalysis.mode": "automatic",
    "files.exclude": {
        "**/.classpath": true,
        "**/.project": true,
        "**/.settings": true,
        "**/.factorypath": true
    },
    "java.project.sourcePaths": [
        "HospitalManagementApp/src/main/java"
    ],
    "java.project.outputPath": "HospitalManagementApp/src/main/webapp/WEB-INF/classes",
    "java.project.referencedLibraries": [
        "HospitalManagementApp/src/main/webapp/WEB-INF/lib/**/*.jar"
    ]
}
```

### `.vscode/launch.json` (for debugging)

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "java",
            "name": "Debug Servlet",
            "request": "attach",
            "hostName": "localhost",
            "port": 5005,
            "projectName": "HospitalManagementApp"
        }
    ]
}
```

---

## Step 6: Running and Debugging

### Start Tomcat from VS Code

1. **Using Tomcat Extension:**
   - Click Tomcat icon in sidebar
   - Right-click server → `Start`
   - View logs in Output panel

2. **Using Terminal:**
   ```bash
   # Windows
   "C:\Program Files\Apache Tomcat\bin\startup.bat"
   
   # Linux/Mac
   /opt/tomcat/bin/startup.sh
   ```

### Debugging

1. Set breakpoints in your Java files
2. Start Tomcat in debug mode (add to `catalina.bat` or use Tomcat extension debug option)
3. Attach debugger using `launch.json` configuration

---

## Quick Workflow

### Daily Development Workflow:

1. **Make code changes** in VS Code
2. **Build:** Press `Ctrl+Shift+B` → Select "Build WAR File"
3. **Deploy:** Right-click `HospitalManagementApp.war` → "Run on Tomcat Server"
4. **Test:** Open `http://localhost:8080/HospitalManagementApp/`

### One-Time Setup Checklist:

- [ ] Install VS Code extensions (Java Pack, Tomcat, MySQL)
- [ ] Configure Java runtime in VS Code
- [ ] Add MySQL JDBC driver to `WEB-INF/lib/`
- [ ] Setup database using `database_setup.sql`
- [ ] Configure Tomcat server in VS Code
- [ ] Create `.vscode/tasks.json` for building
- [ ] Test build process (`Ctrl+Shift+B`)
- [ ] Deploy and verify application works

---

## Troubleshooting

### Issue: Java not detected
**Solution:**
- Install "Extension Pack for Java"
- Set `JAVA_HOME` environment variable
- Restart VS Code

### Issue: Tomcat extension not working
**Solution:**
- Verify Tomcat path is correct
- Check Tomcat is not already running
- Restart VS Code

### Issue: Build fails
**Solution:**
- Check Java files compile: `javac -version`
- Verify servlet-api.jar is accessible
- Check MySQL connector is in `WEB-INF/lib/`

### Issue: 404 Error after deployment
**Solution:**
- Check WAR file name matches context path
- Verify deployment in Tomcat logs
- Check `webapps/` directory for extracted folder

### Issue: Database connection fails
**Solution:**
- Verify MySQL is running
- Check credentials in service files
- Test connection using MySQL extension

---

## VS Code Shortcuts Reference

| Action | Shortcut |
|--------|----------|
| Open Command Palette | `Ctrl+Shift+P` |
| Build Project | `Ctrl+Shift+B` |
| Open Terminal | `Ctrl+`` (backtick) |
| Open Settings | `Ctrl+,` |
| Quick Open File | `Ctrl+P` |
| Go to Symbol | `Ctrl+Shift+O` |
| Format Document | `Shift+Alt+F` |

---

## Next Steps

1. **Set up Git** (if not already):
   - Install Git extension
   - Initialize repository: `git init`
   - Create `.gitignore` for build artifacts

2. **Add Maven/Gradle** for better dependency management

3. **Configure environment variables** for database credentials

4. **Set up CI/CD** using GitHub Actions or similar

---

**Happy Coding! 🚀**

For more help, check:
- [VS Code Java Documentation](https://code.visualstudio.com/docs/languages/java)
- [Tomcat Extension Docs](https://marketplace.visualstudio.com/items?itemName=adashen.vscode-tomcat)



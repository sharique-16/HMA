# Hospital Management App - Deployment Guide

This guide covers how to deploy the Hospital Management Application, a Java web application using JSP/Servlets with MySQL database.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Database Setup](#database-setup)
3. [Building the Application](#building-the-application)
4. [Deploying to Apache Tomcat](#deploying-to-apache-tomcat)
5. [Production Configuration](#production-configuration)
6. [Alternative Deployment Options](#alternative-deployment-options)

---

## Prerequisites

Before deploying, ensure you have the following installed:

- **Java JDK 8 or higher** (JDK 11+ recommended)
- **Apache Tomcat 9.x or 10.x** (or compatible servlet container)
- **MySQL Server 5.7+ or MySQL 8.0+**
- **MySQL JDBC Driver** (mysql-connector-java-8.0.x.jar or higher)
- **Build tool** (Maven, Gradle, or manual compilation)

---

## Database Setup

### 1. Install and Start MySQL

```bash
# On Windows (if using MySQL installer)
# Start MySQL service from Services or use:
net start MySQL80

# On Linux/Mac
sudo systemctl start mysql
# or
sudo service mysql start
```

### 2. Create Database and Tables

Connect to MySQL and create the database:

```sql
-- Connect to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE hospital;

-- Use the database
USE hospital;

-- Create authentication table
CREATE TABLE authentication (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- Create patient table
CREATE TABLE patient (
    patientId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT,
    address VARCHAR(500),
    mobile VARCHAR(20),
    gender VARCHAR(10)
);

-- Create doctor table
CREATE TABLE doctor (
    doctorId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department VARCHAR(100),
    availability BOOLEAN DEFAULT TRUE
);

-- Create appointment table
CREATE TABLE appointment (
    appointmentId INT AUTO_INCREMENT PRIMARY KEY,
    dateAndTime DATETIME NOT NULL,
    department VARCHAR(100),
    doctorId INT,
    patientId INT,
    payment DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'booked',
    FOREIGN KEY (doctorId) REFERENCES doctor(doctorId),
    FOREIGN KEY (patientId) REFERENCES patient(patientId)
);
```

### 3. Update Database Credentials (IMPORTANT)

**⚠️ Security Warning:** The application currently has hardcoded database credentials. Before deploying to production, you should:

1. **Create a dedicated database user** (don't use root):
```sql
CREATE USER 'hospital_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON hospital.* TO 'hospital_user'@'localhost';
FLUSH PRIVILEGES;
```

2. **Update connection strings** in all service implementation files:
   - `AuthenticationServiceImpl.java`
   - `ProfileServiceImpl.java`
   - `AppointmentServiceImpl.java`
   - `DoctorServiceImpl.java`

   Change from:
   ```java
   Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital", "root", "root");
   ```
   
   To:
   ```java
   Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital", "hospital_user", "secure_password");
   ```

   **Better approach:** Use environment variables or a configuration file for production.

---

## Building the Application

### Option 1: Using Maven (Recommended)

If you have a `pom.xml` file:

```bash
cd HospitalManagementApp
mvn clean package
```

The WAR file will be created in `target/HospitalManagementApp.war`

### Option 2: Using Eclipse IDE

1. Right-click on the project
2. Select **Export** → **WAR file**
3. Choose destination and export

### Option 3: Manual Build

1. **Compile Java files:**
```bash
cd HospitalManagementApp/src/main/java
javac -cp "path/to/servlet-api.jar:path/to/mysql-connector.jar" com/hma/packages/**/*.java
```

2. **Copy compiled classes:**
```bash
# Copy .class files to WEB-INF/classes
```

3. **Create WAR file structure:**
```
HospitalManagementApp.war
├── WEB-INF/
│   ├── classes/
│   │   └── com/hma/packages/...
│   └── lib/
│       └── mysql-connector-java-8.0.x.jar
├── *.html
├── *.jsp
└── META-INF/
```

4. **Create WAR file:**
```bash
cd HospitalManagementApp/src/main/webapp
jar cvf ../../../HospitalManagementApp.war *
```

---

## Deploying to Apache Tomcat

### 1. Download and Install Tomcat

- Download from: https://tomcat.apache.org/
- Extract to a directory (e.g., `C:\Program Files\Apache Tomcat` or `/opt/tomcat`)

### 2. Add MySQL JDBC Driver

Copy the MySQL JDBC driver JAR file to Tomcat's lib directory:

```bash
# Copy mysql-connector-java-8.0.x.jar to:
# Windows: C:\Program Files\Apache Tomcat\lib\
# Linux/Mac: /opt/tomcat/lib/
```

### 3. Deploy the WAR File

**Method 1: Copy WAR to webapps directory**

```bash
# Copy your WAR file to Tomcat's webapps directory
# Windows:
copy HospitalManagementApp.war "C:\Program Files\Apache Tomcat\webapps\"

# Linux/Mac:
cp HospitalManagementApp.war /opt/tomcat/webapps/
```

**Method 2: Use Tomcat Manager**

1. Access Tomcat Manager: `http://localhost:8080/manager/html`
2. Upload WAR file through the web interface
3. Deploy

**Method 3: Manual Deployment**

1. Stop Tomcat
2. Copy WAR file to `webapps/` directory
3. Start Tomcat

### 4. Start Tomcat

```bash
# Windows
"C:\Program Files\Apache Tomcat\bin\startup.bat"

# Linux/Mac
/opt/tomcat/bin/startup.sh
```

### 5. Access the Application

Open your browser and navigate to:
```
http://localhost:8080/HospitalManagementApp/
```

---

## Production Configuration

### 1. Environment Variables

Create a configuration class to read database credentials from environment variables:

```java
public class DatabaseConfig {
    private static final String DB_URL = System.getenv("DB_URL") != null 
        ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/hospital";
    private static final String DB_USER = System.getenv("DB_USER") != null 
        ? System.getenv("DB_USER") : "root";
    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD") != null 
        ? System.getenv("DB_PASSWORD") : "root";
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
```

### 2. Connection Pooling

For production, use a connection pool (e.g., HikariCP or Apache DBCP) instead of creating connections directly.

### 3. Tomcat Configuration

**server.xml** - Update for production:
```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           maxThreads="200"
           minSpareThreads="10" />
```

### 4. Security Considerations

- ✅ Use HTTPS in production
- ✅ Change default Tomcat ports
- ✅ Use strong database passwords
- ✅ Implement proper error handling (don't expose stack traces)
- ✅ Add input validation and SQL injection prevention
- ✅ Use prepared statements (already implemented ✓)
- ✅ Implement session timeout
- ✅ Add CSRF protection

---

## Alternative Deployment Options

### 1. Docker Deployment

Create a `Dockerfile`:

```dockerfile
FROM tomcat:9-jdk11-openjdk

# Copy WAR file
COPY HospitalManagementApp.war /usr/local/tomcat/webapps/

# Copy MySQL connector
COPY mysql-connector-java-8.0.33.jar /usr/local/tomcat/lib/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

Build and run:
```bash
docker build -t hospital-app .
docker run -p 8080:8080 --link mysql-container:mysql hospital-app
```

### 2. Cloud Platforms

**AWS Elastic Beanstalk:**
- Package as WAR file
- Upload to Elastic Beanstalk
- Configure RDS MySQL database

**Google Cloud Platform:**
- Deploy to App Engine or Cloud Run
- Use Cloud SQL for MySQL

**Azure:**
- Deploy to Azure App Service
- Use Azure Database for MySQL

**Heroku:**
- Add `Procfile` with Tomcat configuration
- Use Heroku Postgres or ClearDB MySQL addon

### 3. VPS Deployment

1. Set up Ubuntu/CentOS server
2. Install Java, Tomcat, MySQL
3. Configure firewall (open ports 80, 443, 8080)
4. Set up reverse proxy with Nginx
5. Configure SSL certificate (Let's Encrypt)
6. Set up systemd service for Tomcat

---

## Troubleshooting

### Common Issues

1. **ClassNotFoundException: com.mysql.cj.jdbc.Driver**
   - Solution: Ensure MySQL JDBC driver is in `WEB-INF/lib/` or Tomcat's `lib/` directory

2. **Connection refused to database**
   - Solution: Check MySQL is running and credentials are correct

3. **404 Error after deployment**
   - Solution: Check WAR file name matches context path, verify deployment in Tomcat logs

4. **Port already in use**
   - Solution: Change Tomcat port in `server.xml` or stop conflicting service

### Logs Location

- **Tomcat logs:** `$CATALINA_HOME/logs/`
- **Application logs:** Check Tomcat console output

---

## Quick Start Checklist

- [ ] MySQL installed and running
- [ ] Database `hospital` created with required tables
- [ ] MySQL JDBC driver added to project
- [ ] Application compiled and WAR file created
- [ ] Tomcat installed and configured
- [ ] WAR file deployed to Tomcat
- [ ] Tomcat started successfully
- [ ] Application accessible at `http://localhost:8080/HospitalManagementApp/`
- [ ] Database credentials updated (if not using defaults)
- [ ] Production security measures implemented

---

## Support

For issues or questions, check:
- Application logs in Tomcat
- MySQL error logs
- Tomcat catalina.out log file

---

**Last Updated:** 2025



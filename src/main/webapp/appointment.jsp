<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.hma.packages.util.DbConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <nav>
        <a href="dashboard.html">Dashboard</a>
        <a href="login.html">Logout</a>
    </nav>

    <h1>Book Appointment</h1>

    <form class="page-card" action="bookAppointment" method="POST">
        <div id="msg"></div>

        <label for="department">Department</label>
        <input name="department" id="department" required>

        <label for="patientId">Patient ID</label>
        <input type="number" name="patientId" id="patientId" min="1" required>

        <label for="payment">Payment Amount</label>
        <input type="number" name="payment" id="payment" min="0" step="0.01" required>

        <label for="dateTime">Date &amp; Time</label>
        <input type="datetime-local" name="dateTime" id="dateTime" required>

        <label for="doctor">Choose Doctor</label>
        <select name="doctor" id="doctor" required>
            <option value="">-- Select a doctor --</option>
            <%
                try {
                    Connection connection = DbConnection.getConnection();
                    PreparedStatement statement = connection.prepareStatement(
                        "SELECT doctorId, name, department FROM doctor WHERE availability = true ORDER BY name"
                    );
                    ResultSet resultSet = statement.executeQuery();
                    while (resultSet.next()) {
                        int id = resultSet.getInt("doctorId");
                        String name = resultSet.getString("name");
                        String dept = resultSet.getString("department");
            %>
            <option value="<%= id %>"><%= name %> (<%= dept %>)</option>
            <%
                    }
                    resultSet.close();
                    statement.close();
                    connection.close();
                } catch (Exception e) {
            %>
            <option value="">No doctors available — create one first</option>
            <%
                    e.printStackTrace();
                }
            %>
        </select>

        <button type="submit">Book Appointment</button>
    </form>

    <footer>&copy; 2025 Hospital Management App | All rights reserved</footer>
    <script>
        if (new URLSearchParams(window.location.search).get('error')) {
            const msg = document.getElementById('msg');
            msg.className = 'alert alert-error';
            msg.textContent = 'Could not book appointment. Check patient ID, doctor, and date.';
        }
    </script>
</body>
</html>

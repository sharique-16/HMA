<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.hma.packages.util.DbConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient History</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <nav>
        <a href="dashboard.html">Dashboard</a>
        <a href="AllPatient.jsp">All Patients</a>
        <a href="login.html">Logout</a>
    </nav>

    <h1>Patient Appointment History</h1>

    <table>
        <tr>
            <th>Patient ID</th>
            <th>Patient Name</th>
            <th>Age</th>
            <th>Appointment Date &amp; Time</th>
            <th>Doctor</th>
            <th>Department</th>
            <th>Payment</th>
            <th>Status</th>
        </tr>
        <%
        try {
            String patientIdParam = request.getParameter("id");
            if (patientIdParam == null || patientIdParam.isBlank()) {
        %>
        <tr><td colspan="8">No patient selected.</td></tr>
        <%
            } else {
                Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                    "SELECT p.patientId, p.name AS patient_name, p.age, a.dateAndTime, d.name AS doctor_name, " +
                    "d.department, a.payment, a.status " +
                    "FROM appointment a " +
                    "JOIN patient p ON a.patientId = p.patientId " +
                    "JOIN doctor d ON a.doctorId = d.doctorId " +
                    "WHERE p.patientId = ? " +
                    "ORDER BY a.dateAndTime DESC"
                );
                statement.setInt(1, Integer.parseInt(patientIdParam.trim()));
                ResultSet resultSet = statement.executeQuery();
                boolean hasRows = false;
                while (resultSet.next()) {
                    hasRows = true;
        %>
        <tr>
            <td><%= resultSet.getInt("patientId") %></td>
            <td><%= resultSet.getString("patient_name") %></td>
            <td><%= resultSet.getInt("age") %></td>
            <td><%= resultSet.getString("dateAndTime") %></td>
            <td><%= resultSet.getString("doctor_name") %></td>
            <td><%= resultSet.getString("department") %></td>
            <td><%= resultSet.getBigDecimal("payment") %></td>
            <td><%= resultSet.getString("status") %></td>
        </tr>
        <%
                }
                if (!hasRows) {
        %>
        <tr><td colspan="8">No appointments found for this patient.</td></tr>
        <%
                }
                resultSet.close();
                statement.close();
                connection.close();
            }
        } catch (Exception e) {
        %>
        <tr><td colspan="8">Error loading history: <%= e.getMessage() %></td></tr>
        <%
            e.printStackTrace();
        }
        %>
    </table>

    <footer>&copy; 2025 Hospital Management App | All rights reserved</footer>
</body>
</html>

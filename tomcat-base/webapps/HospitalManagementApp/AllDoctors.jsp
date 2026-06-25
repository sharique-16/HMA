<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.hma.packages.util.DbConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Doctors</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <nav>
        <a href="dashboard.html">Dashboard</a>
        <a href="login.html">Logout</a>
    </nav>

    <h1>All Doctors</h1>

    <table>
        <tr>
            <th>Doctor ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Mobile</th>
            <th>Department</th>
            <th>Experience</th>
            <th>Availability</th>
        </tr>
        <%
            try {
                Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement("SELECT * FROM doctor ORDER BY doctorId DESC");
                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    int id = resultSet.getInt("doctorId");
                    String name = resultSet.getString("name");
                    int age = resultSet.getInt("age");
                    String mobile = resultSet.getString("mobile");
                    String department = resultSet.getString("department");
                    String experience = resultSet.getString("experience");
                    boolean availability = resultSet.getBoolean("availability");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= age %></td>
            <td><%= mobile %></td>
            <td><%= department %></td>
            <td><%= experience != null ? experience : "-" %></td>
            <td>
                <% if (!availability) { %>
                    <form action="makeDoctorAvailable" method="POST" style="margin:0;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit">Mark Available</button>
                    </form>
                <% } else { %>
                    <form action="makeDoctorUnAvailable" method="POST" style="margin:0;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit">Mark Unavailable</button>
                    </form>
                <% } %>
            </td>
        </tr>
        <%
                }
                resultSet.close();
                statement.close();
                connection.close();
            } catch (Exception e) {
        %>
        <tr><td colspan="7">Error loading doctors: <%= e.getMessage() %></td></tr>
        <%
                e.printStackTrace();
            }
        %>
    </table>

    <footer>&copy; 2025 Hospital Management App | All rights reserved</footer>
</body>
</html>

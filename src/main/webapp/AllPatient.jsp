<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.hma.packages.util.DbConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Patients</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <nav>
        <a href="dashboard.html">Dashboard</a>
        <a href="login.html">Logout</a>
    </nav>

    <h1>All Patients</h1>

    <table>
        <tr>
            <th>Patient ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Mobile</th>
            <th>Address</th>
            <th>Gender</th>
            <th>Profile Created</th>
            <th>Action</th>
        </tr>
        <%
        try {
            Connection connection = DbConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement("select * from patient order by patientId desc");
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int id = resultSet.getInt("patientId");
                String name = resultSet.getString("name");
                int age = resultSet.getInt("age");
                String mobile = resultSet.getString("mobile");
                String address = resultSet.getString("address");
                String gender = resultSet.getString("gender");
                String profileCreated = resultSet.getString("created_at");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= age %></td>
            <td><%= mobile %></td>
            <td><%= address %></td>
            <td><%= gender %></td>
            <td><%= profileCreated %></td>
            <td>
                <form action="PatientHistory.jsp" method="get">
                    <input type="hidden" name="id" value="<%= id %>">
                    <button type="submit">View History</button>
                </form>
            </td>
        </tr>
        <%
            }
            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
        %>
        <tr><td colspan="8">Error loading patients: <%= e.getMessage() %></td></tr>
        <%
            e.printStackTrace();
        }
        %>
    </table>

    <footer>&copy; 2025 Hospital Management App | All rights reserved</footer>
</body>
</html>

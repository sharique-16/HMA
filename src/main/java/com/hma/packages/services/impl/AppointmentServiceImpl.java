package com.hma.packages.services.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hma.packages.service.AppointmentService;
import com.hma.packages.util.DbConnection;

public class AppointmentServiceImpl implements AppointmentService {

	@Override
	public void bookAppointment(HttpServletRequest req, HttpServletResponse res) {
		try {
			Connection connection = DbConnection.getConnection();
			PreparedStatement statement = connection.prepareStatement(
					"insert into appointment (dateAndTime, department, doctorId, patientId, payment, status) values (?,?,?,?,?,'booked')");

			String dateTime = req.getParameter("dateTime");
			if (dateTime != null) {
				dateTime = dateTime.replace('T', ' ');
				if (dateTime.length() == 16) {
					dateTime = dateTime + ":00";
				}
			}

			statement.setString(1, dateTime);
			statement.setString(2, req.getParameter("department"));
			statement.setInt(3, Integer.parseInt(req.getParameter("doctor")));
			statement.setInt(4, Integer.parseInt(req.getParameter("patientId")));
			statement.setBigDecimal(5, new BigDecimal(req.getParameter("payment")));

			int noOfRowsAffected = statement.executeUpdate();
			statement.close();
			connection.close();

			if (noOfRowsAffected >= 1) {
				res.sendRedirect("dashboard.html?msg=appointment-booked");
			} else {
				res.sendRedirect("appointment.jsp?error=save-failed");
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				res.sendRedirect("appointment.jsp?error=invalid-data");
			} catch (Exception ignored) {
			}
		}
	}
}

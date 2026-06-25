package com.hma.packages.services.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hma.packages.service.ProfileService;
import com.hma.packages.util.DbConnection;

public class ProfileServiceImpl implements ProfileService {

	@Override
	public void createPatientProfile(HttpServletRequest req, HttpServletResponse res) {
		try {
			Connection connection = DbConnection.getConnection();
			PreparedStatement statement = connection.prepareStatement(
					"insert into patient (name, age, address, mobile, gender) values (?,?,?,?,?)");

			statement.setString(1, req.getParameter("name"));
			statement.setInt(2, Integer.parseInt(req.getParameter("age")));
			statement.setString(3, req.getParameter("address"));
			statement.setString(4, req.getParameter("mobile"));
			statement.setString(5, req.getParameter("gender"));

			int noOfRowsAffected = statement.executeUpdate();
			statement.close();
			connection.close();

			if (noOfRowsAffected >= 1) {
				res.sendRedirect("dashboard.html?msg=patient-created");
			} else {
				res.sendRedirect("createPatientProfile.html?error=save-failed");
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				res.sendRedirect("createPatientProfile.html?error=invalid-data");
			} catch (Exception ignored) {
			}
		}
	}

	@Override
	public void createDoctorProfile(HttpServletRequest req, HttpServletResponse res) {
		try {
			Connection connection = DbConnection.getConnection();
			PreparedStatement statement = connection.prepareStatement(
					"insert into doctor (name, age, address, mobile, gender, department, experience, availability) values (?,?,?,?,?,?,?,?)");

			statement.setString(1, req.getParameter("name"));
			statement.setInt(2, Integer.parseInt(req.getParameter("age")));
			statement.setString(3, req.getParameter("address"));
			statement.setString(4, req.getParameter("mobile"));
			statement.setString(5, req.getParameter("gender"));
			statement.setString(6, req.getParameter("department"));
			statement.setString(7, req.getParameter("experience"));
			statement.setBoolean(8, req.getParameter("availability") != null);

			int noOfRowsAffected = statement.executeUpdate();
			statement.close();
			connection.close();

			if (noOfRowsAffected >= 1) {
				res.sendRedirect("dashboard.html?msg=doctor-created");
			} else {
				res.sendRedirect("createDoctorProfile.html?error=save-failed");
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				res.sendRedirect("createDoctorProfile.html?error=invalid-data");
			} catch (Exception ignored) {
			}
		}
	}
}

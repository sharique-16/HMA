package com.hma.packages.services.impl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hma.packages.service.DoctorService;
import com.hma.packages.util.DbConnection;

public class DoctorServiceImpl implements DoctorService{

	@Override
	public void makeDoctorAvailable(HttpServletRequest req, HttpServletResponse res) {
		
		try {
			Connection connection = DbConnection.getConnection();
//			prepare the query
			PreparedStatement statement = connection
					.prepareStatement("update doctor set availability = true where doctorId = ?");

			String id = req.getParameter("id");
			statement.setInt(1, Integer.parseInt(id));
//			Execute the query
			int noOfRowsAffected = statement.executeUpdate();

			if (noOfRowsAffected >= 1) {
				res.sendRedirect("AllDoctors.jsp");
			} else {
				System.err.println("something went wrong");
			}
			// close the connection
			connection.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void makeDoctorUnAvailable(HttpServletRequest req, HttpServletResponse res) {

		try {
			Connection connection = DbConnection.getConnection();
//			prepare the query
			PreparedStatement statement = connection
					.prepareStatement("update doctor set availability = false where doctorId = ?");

			String id = req.getParameter("id");
			statement.setInt(1, Integer.parseInt(id));
//			Execute the query 
			int noOfRowsAffected = statement.executeUpdate();

			if (noOfRowsAffected >= 1) {
				res.sendRedirect("AllDoctors.jsp");
			} else {
				System.err.println("something went wrong");
			}
			// close the connection
			connection.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}

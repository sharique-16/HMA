package com.hma.packages.services.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hma.packages.service.AuthenticationService;
import com.hma.packages.util.DbConnection;

public class AuthenticationServiceImpl implements AuthenticationService {

	@Override
	public void signUp(HttpServletRequest req, HttpServletResponse res) {
		try {
			String email = req.getParameter("email");
			String password = req.getParameter("password");

			if (email == null || email.isBlank() || password == null || password.isBlank()) {
				res.sendRedirect("signup.html?error=missing-fields");
				return;
			}

			Connection connection = DbConnection.getConnection();
			PreparedStatement statement = connection
					.prepareStatement("insert into authentication (email, password) values (?,?)");

			statement.setString(1, email.trim());
			statement.setString(2, password);
			int noOfRowsAffected = statement.executeUpdate();
			statement.close();
			connection.close();

			if (noOfRowsAffected >= 1) {
				res.sendRedirect("login.html?msg=signup-success");
			} else {
				res.sendRedirect("signup.html?error=save-failed");
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
					res.sendRedirect("signup.html?error=email-exists");
				} else {
					res.sendRedirect("signup.html?error=server-error");
				}
			} catch (Exception ignored) {
			}
		}
	}

	@Override
	public void login(HttpServletRequest req, HttpServletResponse res) {
		try {
			String email = req.getParameter("email");
			String password = req.getParameter("password");

			if (email == null || email.isBlank() || password == null || password.isBlank()) {
				res.sendRedirect("login.html?error=missing-fields");
				return;
			}

			Connection connection = DbConnection.getConnection();
			PreparedStatement statement = connection
					.prepareStatement("select userId from authentication where email = ? and password = ?");

			statement.setString(1, email.trim());
			statement.setString(2, password);
			ResultSet resultSet = statement.executeQuery();

			if (resultSet.next()) {
				HttpSession session = req.getSession();
				session.setAttribute("userId", resultSet.getInt("userId"));
				resultSet.close();
				statement.close();
				connection.close();
				res.sendRedirect("dashboard.html");
				return;
			}

			resultSet.close();
			statement.close();
			connection.close();
			res.sendRedirect("login.html?error=invalid-credentials");
		} catch (Exception e) {
			e.printStackTrace();
			try {
				res.sendRedirect("login.html?error=server-error");
			} catch (Exception ignored) {
			}
		}
	}
}

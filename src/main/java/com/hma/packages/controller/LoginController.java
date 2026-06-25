package com.hma.packages.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hma.packages.service.AuthenticationService;
import com.hma.packages.services.impl.AuthenticationServiceImpl;

@WebServlet("/login")
public class LoginController extends HttpServlet {

	private final AuthenticationService service = new AuthenticationServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		service.login(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		service.login(req, resp);
	}
}

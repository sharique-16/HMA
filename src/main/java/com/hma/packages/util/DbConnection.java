package com.hma.packages.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public final class DbConnection {

	private static final Properties PROPS = new Properties();

	static {
		try (InputStream in = DbConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
			if (in != null) {
				PROPS.load(in);
			}
		} catch (Exception e) {
			throw new ExceptionInInitializerError(e);
		}
	}

	private DbConnection() {
	}

	public static Connection getConnection() throws Exception {
		Class.forName("com.mysql.cj.jdbc.Driver");
		String url = PROPS.getProperty("db.url", "jdbc:mysql://localhost:3306/hospital");
		if (!url.contains("serverTimezone")) {
			url += (url.contains("?") ? "&" : "?") + "serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true";
		}
		String user = PROPS.getProperty("db.user", "root");
		String password = PROPS.getProperty("db.password", "");
		return DriverManager.getConnection(url, user, password);
	}
}

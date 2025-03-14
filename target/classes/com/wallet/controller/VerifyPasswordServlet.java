package com.wallet.controller;

import com.wallet.dao.UserDao;
import com.wallet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

@WebServlet("/VerifyPasswordServlet")
public class VerifyPasswordServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/e_wallet";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String password = request.getParameter("password");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (user == null || password == null || password.trim().isEmpty()) {
            out.write("{\"valid\": false}");
            return;
        }

        Connection connection = null;
        try {
            // Connexion à la base de données
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            UserDao userDao = new UserDao(connection);

            // Vérification du mot de passe en base de données
            boolean isValid = userDao.verifyPassword(user.getUsername(), password);

            out.write("{\"valid\": " + isValid + "}");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"valid\": false}");
        } finally {
            try {
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

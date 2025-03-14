package com.wallet.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.wallet.dao.UserDao;
import com.wallet.model.User;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/e_wallet";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equals(currentUser.getUsername())) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        String userIdStr = request.getParameter("userId");
        String adminPassword = request.getParameter("password");

        if (userIdStr == null || userIdStr.isEmpty() || adminPassword == null || adminPassword.isEmpty()) {
            response.sendRedirect("manage_users.jsp?error=missing_data");
            return;
        }

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            UserDao userDao = new UserDao(connection);

            int userId = Integer.parseInt(userIdStr);

            boolean isPasswordValid = userDao.verifyPassword(currentUser.getUsername(), adminPassword);
            if (!isPasswordValid) {
                response.sendRedirect("manage_users.jsp?error=invalid_password");
                return;
            }

            boolean isDeleted = userDao.deleteUser(userId);
            if (isDeleted) {
                response.sendRedirect("manage_users.jsp?success=user_deleted");
            } else {
                response.sendRedirect("manage_users.jsp?error=delete_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp?error=server_error");
        }
    }
}

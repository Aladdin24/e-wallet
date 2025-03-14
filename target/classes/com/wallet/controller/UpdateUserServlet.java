package com.wallet.controller;

import com.wallet.dao.UserDao;
import com.wallet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        double balance = Double.parseDouble(request.getParameter("balance"));

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
            UserDao userDao = new UserDao(connection);
            User user = new User();
            user.setId(userId);
            user.setUsername(username);
            user.setBalance(balance);

            boolean updated = userDao.updateUser(user);
            
            if (updated) {
                response.sendRedirect("manage_users.jsp?success=update");
            } else {
                response.sendRedirect("manage_users.jsp?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp?error=database_error");
        }
    }
}

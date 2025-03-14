package com.wallet.controller;

import com.wallet.dao.TransactionDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

@WebServlet("/adminNotifications")
public class NotificationAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	
    	
    	
        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
            TransactionDao transactionDao = new TransactionDao(connection);
            int newTransactionCount = transactionDao.getNewTransactionCountForAdmin();

            response.setContentType("application/json");
            response.getWriter().write("{\"count\":" + newTransactionCount + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

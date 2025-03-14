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

import com.wallet.dao.TransactionDao;
import com.wallet.model.User;

@WebServlet("/markAdminTransactionsAsSeen")
public class MarkAdminTransactionsAsSeenServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	 HttpSession session = request.getSession(false);
         User user = (User) session.getAttribute("user");

         if (user == null) {
             response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
             return;
         }

    	
        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
            TransactionDao transactionDao = new TransactionDao(connection);
            transactionDao.markTransactionsAsSeenByAdmin();
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

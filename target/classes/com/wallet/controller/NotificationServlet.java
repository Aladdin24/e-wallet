package com.wallet.controller;
import com.wallet.service.TransactionService;
import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.wallet.model.User;
import com.wallet.service.TransactionService;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        TransactionService transactionService = new TransactionService();
        int newTransactionsCount;
		try {
			newTransactionsCount = transactionService.getUnreadTransactionsCount(user.getId());
			 response.setContentType("application/json");
		        response.getWriter().write("{\"count\":" + newTransactionsCount + "}");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
       
    }
}

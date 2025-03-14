package com.wallet.controller;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import com.mysql.jdbc.Connection;
import com.wallet.dao.TransactionDao;
import com.wallet.model.Transaction;

@WebServlet("/AgentValidationServlet")
public class AgentValidationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String withdrawalCode = request.getParameter("withdrawalCode");

        try (Connection connection = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet","root","")) {
            TransactionDao transactionDao = new TransactionDao(connection);
            Transaction transaction = transactionDao.getTransactionByWithdrawalCode(withdrawalCode);

            if (transaction != null && transaction.getWithdrawalCode().equals(withdrawalCode)) {
                transaction.setWithdrawalCode(null); // Invalide le code pour éviter les réutilisations
                transactionDao.updateTransaction(transaction);
                response.sendRedirect("agentDashboard.jsp?success=withdrawal_validated");
            } else {
                response.sendRedirect("agentDashboard.jsp?error=invalid_code");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("agentDashboard.jsp?error=database_error");
        }
    }
}

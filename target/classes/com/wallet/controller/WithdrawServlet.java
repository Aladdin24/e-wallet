package com.wallet.controller;

import com.wallet.dao.TransactionDao;
import com.wallet.dao.UserDao;
import com.wallet.model.Transaction;
import com.wallet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {

    private static final double WITHDRAWAL_FEE_PERCENTAGE = 0.02; // 2% de frais de retrait

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Ne crée pas de nouvelle session si inexistante
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        User user = (User) session.getAttribute("user");
        String amountStr = request.getParameter("amount");
        String password = request.getParameter("password");

        try {
            double amount = Double.parseDouble(amountStr);

            if (amount <= 0 || user.getBalance() < amount) {
                response.sendRedirect("withdraw.jsp?error=invalid_or_insufficient_balance");
                return;
            }

            double fee = amount * WITHDRAWAL_FEE_PERCENTAGE;
            double totalAmount = amount + fee;

            if (user.getBalance() < totalAmount) {
                response.sendRedirect("withdraw.jsp?error=insufficient_balance_for_fee&fee=" + fee);
                return;
            }

            if (password == null || !user.getPassword().equals(password)) {
                response.sendRedirect("withdraw.jsp?error=invalid_password");
                return;
            }

            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
                UserDao userDao = new UserDao(connection);
                TransactionDao transactionDao = new TransactionDao(connection);

                connection.setAutoCommit(false);

                double newBalance = user.getBalance() - totalAmount;
                user.setBalance(newBalance);
                userDao.updateUserBalance(user.getId(), newBalance);

                User adminUser = userDao.getUserByUsername("admin");
                if (adminUser == null) {
                    connection.rollback();
                    response.sendRedirect("withdraw.jsp?error=admin_not_found");
                    return;
                }

                double adminNewBalance = adminUser.getBalance() + amount;
                userDao.updateUserBalance(adminUser.getId(), adminNewBalance);

                Transaction transaction = new Transaction();
                transaction.setSenderId(user.getId());
                transaction.setSenderUsername(user.getUsername());
                transaction.setReceiverId(adminUser.getId());
                transaction.setReceiverUsername(adminUser.getUsername());
                transaction.setAmount(-totalAmount);
                transaction.setTransactionDate(new Timestamp(System.currentTimeMillis()));

                boolean success = transactionDao.addTransaction(transaction);

                if (!success) {
                    connection.rollback();
                    response.sendRedirect("withdraw.jsp?error=transaction_failed");
                    return;
                }

                connection.commit();
                response.sendRedirect("withdraw.jsp?success=withdrawal_to_admin&fee=" + fee);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("withdraw.jsp?error=database_error");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("withdraw.jsp?error=invalid_amount");
        }
    }
}

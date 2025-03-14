package com.wallet.controller;

import com.wallet.dao.TransactionDao;
import com.wallet.dao.UserDao;
import com.wallet.model.Transaction;
import com.wallet.model.User;

<<<<<<< HEAD
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
=======
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
>>>>>>> b0e0283 (Réinitialisation du projet et ajout des fichiers)
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/DepositServlet")
public class DepositServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        double amount = Double.parseDouble(request.getParameter("amount"));

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
            UserDao userDao = new UserDao(connection);
            TransactionDao transactionDao = new TransactionDao(connection);
            
            // Récupérer l'utilisateur cible
            User user = userDao.getUserById(userId);
            if (user == null) {
                response.sendRedirect("manage_users.jsp?error=user_not_found");
                return;
            }
            
            

            // Mettre à jour le solde de l'utilisateur
            double newBalance = user.getBalance() + amount;
            user.setBalance(newBalance);
            userDao.updateUserBalance(user.getId(), newBalance);

         // Supposons que l'administrateur ait un nom d'utilisateur spécifique
            User adminUser = userDao.getUserByUsername("admin");
            int adminId = (adminUser != null) ? adminUser.getId() : 0;

            Transaction transaction = new Transaction();
            transaction.setSenderId(adminId); // Utiliser l'ID réel de l'administrateur
            transaction.setSenderUsername("admin");
            transaction.setReceiverId(user.getId());
            transaction.setReceiverUsername(user.getUsername());
            transaction.setAmount(amount);
            transaction.setTransactionDate(new Timestamp(System.currentTimeMillis()));
            
            transactionDao.addTransaction(transaction);

            response.sendRedirect("manage_users.jsp?success=deposit_completed");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp?error=database_error");
        }
    }
}

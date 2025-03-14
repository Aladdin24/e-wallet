package com.wallet.controller;

import com.google.gson.Gson;
import com.wallet.dao.TransactionDao;
import com.wallet.dao.UserDao;
import com.wallet.model.Transaction;
import com.wallet.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class TransactionServlet extends HttpServlet {

    // Méthode pour gérer les requêtes POST (envoi d'argent)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sender = (User) session.getAttribute("user");

        if (sender == null) {
            // Redirection vers la page de connexion si l'utilisateur n'est pas connecté
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("confirm".equals(action)) {
            // Étape 2 : Validation du mot de passe et exécution de la transaction
            confirmAndProcessTransaction(request, response, sender);
        } else {
            // Étape 1 : Validation des données initiales et redirection vers la page de confirmation
            validateAndRedirectToConfirmation(request, response, sender);
        }
    }

    private void validateAndRedirectToConfirmation(HttpServletRequest request, HttpServletResponse response, User sender) throws ServletException, IOException {
        // Récupération des paramètres du formulaire
        String receiverUsername = request.getParameter("receiverUsername");
        String amountStr = request.getParameter("amount");

        try {
            // Conversion du montant en double
            double amount = Double.parseDouble(amountStr);

            // Validation des données
            if (receiverUsername == null || receiverUsername.isEmpty() || amount <= 0) {
                response.sendRedirect("dashboard.jsp?error=invalid");
                return;
            }

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "");

            // Création des instances de UserDao et TransactionDao
            UserDao userDao = new UserDao(connection);
            User receiver = userDao.getUserByUsername(receiverUsername);

            // Vérification que le destinataire existe
            if (receiver == null) {
                response.sendRedirect("dashboard.jsp?error=receiver_not_found");
                return;
            }

            // Vérification que l'utilisateur n'envoie pas à lui-même
            if (sender.getId() == receiver.getId()) {
                response.sendRedirect("dashboard.jsp?error=self_transaction");
                return;
            }

            // Vérification que l'expéditeur a suffisamment de solde
            if (sender.getBalance() < amount) {
                response.sendRedirect("dashboard.jsp?error=insufficient_balance");
                return;
            }

            // Stockage des données dans la session pour utilisation ultérieure
            HttpSession session = request.getSession();
            session.setAttribute("transactionReceiverUsername", receiverUsername);
            session.setAttribute("transactionAmount", amount);

            // Redirection vers la page de confirmation
            response.sendRedirect("confirm_transaction.jsp");
            connection.close();
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp?error=invalid_amount");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=unexpected");
        }
    }

    private void confirmAndProcessTransaction(HttpServletRequest request, HttpServletResponse response, User sender) throws ServletException, IOException {
        // Récupération des données stockées dans la session
        HttpSession session = request.getSession(false);
        String receiverUsername = (String) session.getAttribute("transactionReceiverUsername");
        Double amount = (Double) session.getAttribute("transactionAmount");

        // Récupération du mot de passe saisi par l'utilisateur
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "");

            // Création des instances de UserDao et TransactionDao
            UserDao userDao = new UserDao(connection);
            TransactionDao transactionDao = new TransactionDao(connection);

            // Vérification du mot de passe
            boolean isValidPassword = userDao.validateUserPassword(sender.getUsername(), password);
            if (!isValidPassword) {
                response.sendRedirect("confirm_transaction.jsp?error=invalid_password");
                return;
            }

            // Récupération du destinataire
            User receiver = userDao.getUserByUsername(receiverUsername);

            // Début de la transaction SQL
            connection.setAutoCommit(false);
            try {
                // Mise à jour du solde de l'expéditeur
                sender.setBalance(sender.getBalance() - amount);
                userDao.updateUserBalance(sender.getId(), sender.getBalance());

                // Mise à jour du solde du destinataire
                receiver.setBalance(receiver.getBalance() + amount);
                userDao.updateUserBalance(receiver.getId(), receiver.getBalance());

                // Enregistrement de la transaction
                Transaction transaction = new Transaction();
                transaction.setSenderId(sender.getId());
                transaction.setSenderUsername(sender.getUsername());
                transaction.setReceiverId(receiver.getId());
                transaction.setReceiverUsername(receiver.getUsername());
                transaction.setAmount(amount);
                transaction.setTransactionDate(new Timestamp(System.currentTimeMillis()));
                boolean success = transactionDao.addTransaction(transaction);

                if (!success) {
                    throw new SQLException("Échec de l'enregistrement de la transaction.");
                }

                // Validation de la transaction SQL
                connection.commit();

                // Suppression des données temporaires de la session
                session.removeAttribute("transactionReceiverUsername");
                session.removeAttribute("transactionAmount");

                // Redirection avec un message de succès
                response.sendRedirect("dashboard.jsp?success=true");
            } catch (Exception e) {
                // Annulation de la transaction SQL en cas d'erreur
                connection.rollback();
                response.sendRedirect("dashboard.jsp?error=transaction_failed");
            } finally {
                // Rétablissement du mode auto-commit
                connection.setAutoCommit(true);
                connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=unexpected");
        }
    }
    
    


    
}
package com.wallet.controller;

import com.google.gson.Gson;
import com.wallet.dao.TransactionDao;
import com.wallet.model.Transaction;
import com.wallet.model.User;

<<<<<<< HEAD
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
=======
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
>>>>>>> b0e0283 (Réinitialisation du projet et ajout des fichiers)
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.List;

@WebServlet("/transaction-data")
public class TransactionDataServlet extends HttpServlet {
    
    public TransactionDataServlet() {
        super(); // Constructeur public par défaut requis par Tomcat
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Utilisateur non authentifié\"}");
            return;
        }

        int userId = user.getId(); // Utiliser l'ID utilisateur de la session

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
            TransactionDao transactionDao = new TransactionDao(connection);
            List<Transaction> transactions = transactionDao.getUserTransactions(userId);

            Gson gson = new Gson();
            String json = gson.toJson(transactions);
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Erreur du serveur\"}");
        }
    }
}

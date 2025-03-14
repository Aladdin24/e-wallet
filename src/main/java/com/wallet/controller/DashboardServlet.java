// DashboardServlet.java
package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.TransactionService;

<<<<<<< HEAD
import javax.servlet.*;
import javax.servlet.http.*;
=======
import jakarta.servlet.*;
import jakarta.servlet.http.*;
>>>>>>> b0e0283 (Réinitialisation du projet et ajout des fichiers)
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupération de l'utilisateur connecté depuis la session
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Création d'une instance de TransactionService
        TransactionService transactionService = new TransactionService();

        try {
            // Récupération des transactions via le service
            List<com.wallet.model.Transaction> transactions = transactionService.getUserTransactions(user.getId());

            // Transmission des transactions à la JSP
            request.setAttribute("transactions", transactions);

            // Redirection vers la page dashboard.jsp
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
package com.wallet.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    // Méthode pour gérer les requêtes GET (déconnexion)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupération de la session actuelle (s'il y en a une)
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Invalidation de la session pour déconnecter l'utilisateur
            session.invalidate();
        }

        // Redirection vers la page de connexion
        response.sendRedirect("login.jsp");
    }

    // Méthode pour gérer les requêtes POST (optionnel, si nécessaire)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Appel de la méthode doGet pour un comportement identique
        doGet(request, response);
    }
}
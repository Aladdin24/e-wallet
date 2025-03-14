package com.wallet.controller;

import com.wallet.dao.UserDao;
import com.wallet.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

public class RegisterServlet extends HttpServlet {

    // Méthode pour gérer les requêtes POST (inscription)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupération des paramètres du formulaire
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation côté serveur
        if (username == null || email == null || password == null || !password.equals(confirmPassword)) {
            // Redirection vers la page d'inscription avec un message d'erreur
            response.sendRedirect("register.jsp?error=invalid");
            return;
        }

        try {
            // Chargement du pilote JDBC MySQL
        	Class.forName("com.mysql.jdbc.Driver");
        	Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet","root","");

            // Création d'une instance de UserDao
            UserDao userDao = new UserDao(connection);

            // Vérification si l'utilisateur existe déjà (par nom d'utilisateur ou email)
            User existingUser = userDao.getUserByUsernameOrEmail(username, email);
            if (existingUser != null) {
                // Redirection vers la page d'inscription avec un message d'erreur
                response.sendRedirect("register.jsp?error=exists");
            } else {
                // Création d'un nouvel utilisateur
                User newUser = new User();
                newUser.setUsername(username);
                newUser.setPassword(password); // Note : Dans une application réelle, hachez le mot de passe avant de le stocker
                newUser.setEmail(email);
                newUser.setBalance(0.0); // Solde initial à 0

                // Enregistrement de l'utilisateur dans la base de données
                boolean success = userDao.registerUser(newUser);
                if (success) {
                    // Redirection vers la page de connexion avec un message de succès
                    response.sendRedirect("login.jsp?success=true");
                } else {
                    // Redirection vers la page d'inscription avec un message d'erreur
                    response.sendRedirect("register.jsp?error=invalid");
                }
            }

            // Fermeture de la connexion
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
            // Redirection vers la page d'inscription en cas d'erreur inattendue
            response.sendRedirect("register.jsp?error=invalid");
        }
    }
}
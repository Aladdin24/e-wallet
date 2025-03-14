<%@ page import="com.wallet.model.User" %>
<%
    // Vérifie si un utilisateur est déjà connecté
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    // Récupération des paramètres d'erreur
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Portefeuille Électronique</title>
    <!-- Lien vers Font Awesome pour les icônes -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        /* Styles globaux */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            font-family: 'Arial', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .form-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
            animation: fadeIn 1.5s ease-in-out;
        }
        .logo {
            font-size: 48px;
            color: #6a11cb;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .input-group {
            position: relative;
            margin-bottom: 15px;
        }
        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: color 0.3s ease;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: #6a11cb;
            box-shadow: 0 0 8px rgba(106, 17, 203, 0.5);
        }
        input[type="text"]:focus + i,
        input[type="email"]:focus + i,
        input[type="password"]:focus + i {
            color: #6a11cb;
        }
        button[type="submit"] {
            background: #6a11cb;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-size: 16px;
            color: #fff;
            width: 100%;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }
        button[type="submit"]:hover {
            background: #2575fc;
            transform: scale(1.05);
        }
        p.text-center {
            margin-top: 20px;
            font-size: 14px;
        }
        p.text-center a {
            color: #6a11cb;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }
        p.text-center a:hover {
            color: #2575fc;
        }
        /* Animations CSS */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }
        /* Effet de fond animé */
        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            z-index: -1;
            animation: moveBackground 10s infinite alternate;
        }
        @keyframes moveBackground {
            0% {
                transform: translateX(-50px) translateY(-50px);
            }
            100% {
                transform: translateX(50px) translateY(50px);
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <!-- Logo -->
        <div class="logo">
            <i class="fas fa-wallet"></i>
        </div>
        <h2>Inscription</h2>

        <!-- Affichage des messages d'erreur -->
        <%
            if ("exists".equals(error)) {
        %>
            <div class="error-message">Cet utilisateur existe déjà.</div>
        <%
            } else if ("invalid".equals(error)) {
        %>
            <div class="error-message">Veuillez remplir tous les champs correctement.</div>
        <%
            }
        %>

        <!-- Formulaire d'inscription -->
        <form action="RegisterServlet" method="post">
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" id="username" name="username" placeholder="Nom d'utilisateur" required>
            </div>
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" id="email" name="email" placeholder="Email" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Mot de passe" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirmer le mot de passe" required>
            </div>
            <button type="submit">S'inscrire</button>
        </form>

        <!-- Lien vers la page de connexion -->
        <p class="text-center">Déjà inscrit ? <a href="login.jsp">Connectez-vous ici</a></p>
    </div>
</body>
</html>
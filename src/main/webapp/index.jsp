<%@ page import="com.wallet.model.User" %>
<%
    // Vérifie si un utilisateur est déjà connecté
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portefeuille Électronique</title>
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
        .hero {
            max-width: 800px;
            width: 100%;
            padding: 40px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        h1 {
            font-size: 36px;
            color: #333;
            margin-bottom: 20px;
            animation: fadeIn 1.5s ease-in-out;
        }
        p {
            font-size: 18px;
            color: #555;
            margin-bottom: 30px;
            animation: fadeIn 2s ease-in-out;
        }
        .btn-container {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .btn {
            padding: 12px 20px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
        }
        .btn-primary {
            background: #6a11cb;
            color: #fff;
        }
        .btn-primary:hover {
            background: #2575fc;
            transform: scale(1.05);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .btn-success {
            background: #28a745;
            color: #fff;
        }
        .btn-success:hover {
            background: #218838;
            transform: scale(1.05);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .logo {
            font-size: 48px;
            color: #6a11cb;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
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
        .hero::before {
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
    <div class="hero">
        <!-- Logo -->
        <div class="logo">
            <i class="fas fa-wallet"></i>
        </div>
        <h1>Bienvenue sur le Portefeuille Électronique</h1>
        <p>Gérez vos finances en toute simplicité avec notre application sécurisée.</p>
        <div class="btn-container">
            <a href="login.jsp" class="btn btn-primary">Se connecter</a>
            <a href="register.jsp" class="btn btn-success">S'inscrire</a>
        </div>
    </div>
</body>
</html>
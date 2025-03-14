<%@ page import="com.wallet.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Récupération des informations de la transaction depuis la session
    String receiverUsername = (String) session.getAttribute("transactionReceiverUsername");
    Double amount = (Double) session.getAttribute("transactionAmount");

    if (receiverUsername == null || amount == null) {
        response.sendRedirect("dashboard.jsp?error=unexpected");
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmer la Transaction - Portefeuille Électronique</title>
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
        }
        h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }
        .info {
            font-size: 16px;
            color: #555;
            margin-bottom: 20px;
            line-height: 1.5;
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
        }
        input[type="password"] {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        input[type="password"]:focus {
            border-color: #6a11cb;
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
            transition: background 0.3s ease;
        }
        button[type="submit"]:hover {
            background: #2575fc;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Confirmer la Transaction</h2>

        <!-- Affichage des messages d'erreur -->
        <%
            if ("invalid_password".equals(error)) {
        %>
            <div class="error-message">Mot de passe incorrect.</div>
        <%
            }
        %>

        <!-- Affichage des informations de la transaction -->
        <div class="info">
            <p><strong>Destinataire :</strong> <%= receiverUsername %></p>
            <p><strong>Montant :</strong> <%= String.format("%.2f", amount) %> MRU</p>
        </div>

        <!-- Formulaire de confirmation -->
        <form action="TransactionServlet" method="post">
            <input type="hidden" name="action" value="confirm">
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Entrez votre mot de passe" required>
            </div>
            <button type="submit">Confirmer</button>
        </form>
    </div>
</body>
</html>
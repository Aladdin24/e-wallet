<%@ page import="com.wallet.model.User" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Transaction - Portefeuille Électronique</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <!-- Barre latérale -->
    <div class="fixed top-0 left-0 w-64 h-screen bg-gradient-to-b from-blue-900 to-blue-700 text-white shadow-lg">
        <h3 class="text-xl font-bold text-center py-6">Mon Portefeuille</h3>
        <nav class="mt-4">
            <a href="dashboard.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-home mr-3"></i> Accueil
            </a>
            <a href="transactions.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-exchange-alt mr-3"></i> Transactions
            </a>
            <a href="#" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-wallet mr-3"></i> Solde
            </a>
                       <a href="withdraw.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-hand-holding-usd mr-2"></i> Retirer
            </a>

            <a href="LogoutServlet" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-sign-out-alt mr-3"></i> Déconnexion
            </a>
        </nav>
    </div>

    <!-- Contenu principal -->
    <div class="ml-64 p-8">
        <div class="max-w-md mx-auto bg-white p-8 rounded-lg shadow-md">
            <h2 class="text-2xl font-bold text-blue-900 flex items-center mb-6">
                <i class="fas fa-plus-circle mr-2"></i> Nouvelle Transaction
            </h2>

            <!-- Messages Dynamiques -->
            <% if ("true".equals(success)) { %>
                <p class="bg-green-100 text-green-700 px-4 py-2 rounded mb-4">Transaction effectuee avec succes !</p>
            <% } else if ("invalid".equals(error)) { %>
                <p class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Donnees invalides. Veuillez reessayer.</p>
            <% } else if ("receiver_not_found".equals(error)) { %>
                <p class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Destinataire non trouve.</p>
            <% } else if ("self_transaction".equals(error)) { %>
                <p class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Vous ne pouvez pas envoyer de l'argent a vous-même.</p>
            <% } else if ("insufficient_balance".equals(error)) { %>
                <p class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Solde insuffisant pour effectuer cette transaction.</p>
            <% } else if ("transaction_failed".equals(error)) { %>
                <p class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Echec de la transaction. Veuillez réessayer.</p>
            <% } else if ("unexpected".equals(error)) { %>
                <p class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Une erreur inattendue est survenue.</p>
            <% } %>

            <!-- Formulaire de Nouvelle Transaction -->
            <form action="TransactionServlet" method="post" class="space-y-4">
                <div>
                    <label for="receiverUsername" class="block text-sm font-medium text-gray-700">
                        <i class="fas fa-user mr-2"></i> Nom du Destinataire
                    </label>
                    <input type="text" id="receiverUsername" name="receiverUsername" 
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-blue-500 focus:ring focus:ring-blue-200"
                           placeholder="Entrez le nom du destinataire" required>
                </div>
                <div>
                    <label for="amount" class="block text-sm font-medium text-gray-700">
                        <i class="fas fa-money-bill-wave mr-2"></i> Montant
                    </label>
                    <input type="number" step="0.01" id="amount" name="amount" 
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-blue-500 focus:ring focus:ring-blue-200"
                           placeholder="Entrez le montant" required>
                </div>
                <button type="submit" 
                        class="w-full bg-blue-900 text-white px-4 py-2 rounded hover:bg-blue-700 transition duration-300 flex items-center justify-center">
                    <i class="fas fa-paper-plane mr-2"></i> Envoyer
                </button>
            </form>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.Transaction" %>
<%@ page import="com.wallet.dao.TransactionDao" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="com.wallet.model.User" %>

<%
    // Vérification de la session utilisateur
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }

    User user = (User) session.getAttribute("user");
    if (!"admin".equals(user.getUsername())) {
        response.sendRedirect("dashboard.jsp?error=access_denied");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions Administrateur</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans flex">
    
  <!-- Barre latérale -->
<div class="fixed top-0 left-0 w-64 h-full bg-gradient-to-b from-blue-900 to-blue-700 text-white shadow-lg">
    <h3 class="text-2xl font-bold text-center py-6">Admin - Mon Portefeuille</h3>
    <nav class="mt-4 space-y-2">
        <a href="admin_dashboard.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
            <i class="fas fa-tachometer-alt mr-3"></i> Tableau de Bord
        </a>
        <a href="manage_users.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
            <i class="fas fa-users mr-3"></i> Utilisateurs
        </a>
        <a href="admin_transactions.jsp" class="flex items-center px-4 py-3 bg-blue-600 rounded transition duration-300">
            <i class="fas fa-exchange-alt mr-3"></i> Transactions
        </a>
        <a href="LogoutServlet" class="flex items-center px-4 py-3 hover:bg-red-600 rounded transition duration-300">
            <i class="fas fa-sign-out-alt mr-3"></i> Déconnexion
        </a>
    </nav>
</div>

<!-- Contenu principal -->
<div class="ml-64 p-8 flex-grow">
    <h2 class="text-3xl font-bold text-blue-900 mb-6">Toutes les Transactions</h2>

    <!-- Barre de recherche -->
    <div class="mb-6 flex items-center">
        <form action="admin_transactions.jsp" method="get" class="flex space-x-2 w-full max-w-md">
            <div class="relative flex-grow">
                <input 
                    type="text" 
                    name="searchSender" 
                    placeholder="Rechercher par nom d'expéditeur..." 
                    class="w-full p-3 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                    value="<%= request.getParameter("searchSender") != null ? request.getParameter("searchSender") : "" %>"
                >
                <span class="absolute top-3 right-3 text-gray-400">
                    <i class="fas fa-search"></i>
                </span>
            </div>
            <button type="submit" class="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition duration-300 flex items-center space-x-2">
                <i class="fas fa-search"></i> <span>Rechercher</span>
            </button>
        </form>
    </div>

    <!-- Tableau des transactions -->
    <div class="bg-white p-6 rounded-lg shadow-md">
        <table class="w-full border-collapse">
            <thead>
                <tr class="bg-blue-500 text-white">
                    <th class="p-2">ID Transaction</th>
                    <th class="p-2">Expéditeur</th>
                    <th class="p-2">Destinataire</th>
                    <th class="p-2">Montant</th>
                    <th class="p-2">Date</th>
                    <th class="p-2">Statut</th>
                </tr>
            </thead>
            <tbody>
                <% 
                Connection connection = null;
                String searchSender = request.getParameter("searchSender");
                try {
                    connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "");
                    TransactionDao transactionDao = new TransactionDao(connection);
                    List<Transaction> transactions;

                    if (searchSender != null && !searchSender.trim().isEmpty()) {
                        transactions = transactionDao.getTransactionsBySenderUsername(searchSender.trim());
                    } else {
                        transactions = transactionDao.getAllTransactions();
                    }

                    for (Transaction transaction : transactions) { 
                        String status = "";
                        String statusClass = "";

                        if ("admin".equals(transaction.getReceiverUsername())) {
                            status = "Retrait";
                            statusClass = "bg-yellow-500";
                        } else if ("admin".equals(transaction.getSenderUsername())) {
                            status = "Dépôt";
                            statusClass = "bg-blue-500";
                        } else if (transaction.getAmount() < 0) {
                            status = "Débit";
                            statusClass = "bg-red-500";
                        } else {
                            status = "Crédit";
                            statusClass = "bg-green-500";
                        }
                %>
                    <tr class="hover:bg-gray-50 border-b transition duration-200">
                        <td class="p-2 text-center"><%= transaction.getId() %></td>
                        <td class="p-2 text-center"><%= transaction.getSenderUsername() %></td>
                        <td class="p-2 text-center"><%= transaction.getReceiverUsername() %></td>
                        <td class="p-2 text-center"><%= String.format("%.2f", transaction.getAmount()) %> MRU</td>
                        <td class="p-2 text-center"><%= transaction.getTransactionDate() %></td>
                        <td class="p-2 text-center">
                            <span class="px-2 py-1 rounded text-white text-sm font-semibold <%= statusClass %> transition-transform transform hover:scale-105">
                                <%= status %>
                            </span>
                        </td>
                    </tr>
                <% 
                    } 
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (connection != null) {
                        try { connection.close(); } catch (Exception e) { e.printStackTrace(); }
                    }
                } 
                %>
            </tbody>
        </table>
    </div>
</div>

    <script>
    // Marquer les transactions comme vues dès le chargement de la page admin
    window.onload = async function() {
        try {
            const response = await fetch('markAdminTransactionsAsSeen', { method: 'POST' });
            if (response.ok) {
                console.log('Transactions marquées comme vues par l\'admin');
                const notificationBadge = document.getElementById('admin-notification-badge');
                if (notificationBadge) {
                    notificationBadge.classList.add('hidden');
                }
            } else {
                console.error('Erreur lors de la mise à jour des transactions pour l\'admin');
            }
        } catch (error) {
            console.error('Erreur de communication avec le serveur :', error);
        }
    };
    </script>
    
</body>
</html>

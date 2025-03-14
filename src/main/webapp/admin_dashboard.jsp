<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wallet.model.User" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="com.wallet.dao.UserDao" %>
<%@ page import="com.wallet.dao.TransactionDao" %>
<%
    // Si la session existe déjà, inutile de la redéclarer
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

<%
    // Connexion à la base de données
    int userCount = 0;
    try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
        UserDao userDao = new UserDao(connection);
        userCount = userDao.getUserCount();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<%
    // Connexion à la base de données pour obtenir le nombre de transactions récentes
    int recentTransactionCount = 0;
    try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
        TransactionDao transactionDao = new TransactionDao(connection);
        recentTransactionCount = transactionDao.getRecentTransactionCount();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<%
    // Connexion à la base de données pour obtenir le solde total
    double totalBalance = 0.0;
    try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "")) {
        UserDao userDao = new UserDao(connection);
        totalBalance = userDao.getTotalBalance();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Administrateur</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script defer>
// Fonction pour vérifier les nouvelles transactions via AJAX
async function checkAdminNewTransactions() {
    try {
        const response = await fetch('adminNotifications'); // Appel à NotificationAdminServlet
        const data = await response.json(); // Réponse attendue : { "count": 2 }

        const notificationBadge = document.getElementById('admin-notification-badge');
        
        if (data.count > 0) {
            notificationBadge.classList.remove('hidden');
            notificationBadge.textContent = data.count; // Affiche le nombre de nouvelles transactions
        } else {
            notificationBadge.classList.add('hidden');
        }

    } catch (error) {
        console.error('Erreur lors de la vérification des transactions :', error);
    }
}

// Appel périodique pour vérifier les nouvelles transactions toutes les 5 secondes
setInterval(checkAdminNewTransactions, 5000);
window.onload = checkAdminNewTransactions;
</script>
    
</head>
<body class="bg-gray-100 font-sans">

    <!-- Barre latérale -->
    <div class="fixed top-0 left-0 w-64 h-screen bg-gradient-to-b from-blue-900 to-blue-700 text-white shadow-lg">
       <h3 class="text-2xl font-bold text-center py-6">Admin - Mon Portefeuille</h3>
        <nav class="mt-4">
            <a href="admin_dashboard.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-tachometer-alt mr-3"></i> Tableau de Bord
            </a>
            <a href="manage_users.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-users mr-3"></i> Utilisateurs
            </a>
         <a href="admin_transactions.jsp" class="relative flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
    <i class="fas fa-exchange-alt mr-3"></i> Transactions
    <!-- Badge de notification caché par défaut -->
    <span id="admin-notification-badge" class="absolute top-1 right-1 bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full hidden">
        NEW
    </span>
</a>

           <a href="LogoutServlet" class="flex items-center px-4 py-3 hover:bg-red-600 rounded transition duration-300">
                <i class="fas fa-sign-out-alt mr-3"></i> Déconnexion
            </a>
        </nav>
    </div>

    <!-- Contenu principal -->
    <div class="ml-64 p-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-2xl font-bold text-blue-900">Bienvenue Administrateur !</h1>
        </div>

        <!-- Section Statistiques -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white p-6 rounded-lg shadow-md flex items-center">
                <i class="fas fa-users fa-2x text-blue-500 mr-4"></i>
               <div>
                    <h2 class="text-lg font-semibold text-blue-900">Utilisateurs Inscrits</h2>
                    <p class="text-4xl font-bold text-gray-700"><%= userCount -1  %></p>
               </div>
            </div>

            <div class="bg-white p-6 rounded-lg shadow-md flex items-center">
                <i class="fas fa-exchange-alt fa-2x text-green-500 mr-4"></i>
               <div>
        <h2 class="text-lg font-semibold text-blue-900">Transactions Récentes</h2>
        <p class="text-4xl font-bold text-gray-700"><%= recentTransactionCount %></p>
    </div>
            </div>

            <div class="bg-white p-6 rounded-lg shadow-md flex items-center">
                <i class="fas fa-wallet fa-2x text-orange-500 mr-4"></i>
                <div>
        <h2 class="text-lg font-semibold text-blue-900">Solde Total</h2>
        <p class="text-4xl font-bold text-gray-700"><%= String.format("%.2f", totalBalance) %> MRU</p>
    </div>
            </div>
        </div>

        <!-- Section Graphique -->
        <div class="bg-white p-6 rounded-lg shadow-md mb-8">
            <h4 class="text-lg font-bold text-blue-900 mb-4">Graphique des Transactions</h4>
            <canvas id="transactionChart"></canvas>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const ctx = document.getElementById('transactionChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                    datasets: [{
                        label: 'Transactions Mensuelles',
                        data: [12, 19, 3, 5, 2, 3, 7],
                        borderColor: 'rgba(54, 162, 235, 1)',
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        fill: true,
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                    },
                }
            });
        </script>
    </div>

</body>
</html>

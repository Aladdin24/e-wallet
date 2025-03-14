<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.service.TransactionService" %>
<%@ page import="com.wallet.model.Transaction" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    TransactionService transactionService = new TransactionService();
    List<Transaction> transactions = null;

    // Récupération de la date sélectionnée (si elle existe)
    String selectedDate = request.getParameter("selectedDate");

    try {
        if (selectedDate != null && !selectedDate.isEmpty()) {
            transactions = transactionService.getUserTransactionsByDate(user.getId(), selectedDate);
        } else {
            transactions = transactionService.getUserTransactions(user.getId());
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<%
            // Récupération du paramètre "tab" depuis l'URL
            String activeTab = request.getParameter("tab");
            if (activeTab == null || !activeTab.equals("transactions")) {
                 activeTab = "home"; // Par défaut, l'onglet "Accueil" est actif
            }
        %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Transactions - Portefeuille Electronique</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script>
    // Marquer les transactions comme vues dès le chargement de la page
    window.onload = async function() {
        try {
            const response = await fetch('markTransactionsAsSeen', { method: 'POST' });
            if (response.ok) {
                console.log('Transactions marquées comme vues');
                // Masquer le badge de notification si besoin
                const notificationBadge = document.getElementById('notification-badge');
                if (notificationBadge) {
                    notificationBadge.classList.add('hidden');
                }
            } else {
                console.error('Erreur lors de la mise à jour des transactions');
            }
        } catch (error) {
            console.error('Erreur de communication avec le serveur :', error);
        }
    };
</script>
    
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

            <a href="LogoutServlet" class="flex items-center px-4 py-3 hover:bg-red-600 rounded transition duration-300">
                <i class="fas fa-sign-out-alt mr-3"></i> Deconnexion
            </a>
        </nav>
    </div>

    <!-- Contenu principal -->
    <div class="ml-64 p-8">
        <h1 class="text-2xl font-bold text-blue-900 mb-6">Historique des Transactions</h1>

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

        <!-- Sélecteur de Date -->
        <form action="transactions.jsp" method="get" class="mb-4">
                      <div class="flex items-center space-x-4">
                           <div class="col-auto">
                                 <label for="selectedDate" class="text-gray-700">Filtrer par date :</label>
                           </div>
                           <div class="col-auto">
                                  <input type="date" id="selectedDate" name="selectedDate" class="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:border-blue-500" value="<%= selectedDate != null ? selectedDate : "" %>">
                           </div>
                           <div class="col-auto">
                                  <input type="hidden" name="tab" value="transactions"> <!-- Garde l'onglet Transactions actif -->
                                  <button type="submit" class="bg-blue-900 text-white px-4 py-2 rounded hover:bg-blue-700 transition duration-300">Filtrer</button>
                           </div>
                      </div>
                </form>

        <!-- Tableau des Transactions -->
        <div class="bg-white p-6 rounded-lg shadow-md">
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-blue-900 text-white">
                        <th class="py-2 px-4 text-left">Date</th>
                        <th class="py-2 px-4 text-left">Destinataire/Expediteur</th>
                        <th class="py-2 px-4 text-left">Montant</th>
                        <th class="py-2 px-4 text-left">Statut</th>
                    </tr>
                </thead>
                <tbody>
    <% if (transactions != null && !transactions.isEmpty()) {
        for (Transaction transaction : transactions) {
            
            String statusClass;
            String statusText;
            String description = "";
            
            if ("admin".equals(transaction.getSenderUsername())) {
                statusClass = "bg-blue-500";
                statusText = "Depot";
                description = "a " + transaction.getReceiverUsername();
            } else if ("admin".equals(transaction.getReceiverUsername())) {
                statusClass = "bg-orange-500";
                statusText = "Retrait";
                
            } else if (transaction.getSenderId() == user.getId()) {
                statusClass = "bg-red-500";
                statusText = "Debit";
                description = "a " + transaction.getReceiverUsername();
            } else {
                statusClass = "bg-green-500";
                statusText = "Credit";
                description = "de " + transaction.getSenderUsername();
            }
    %>
            <tr class="hover:bg-gray-50">
                <td class="py-2 px-4"><%= transaction.getTransactionDate() %></td>
                <td class="py-2 px-4">
                    <% if (!"admin".equals(transaction.getReceiverUsername())) { %>
                        <%= description %>
                    <% } %>
                </td>
                <td class="py-2 px-4"><%= String.format("%.2f", transaction.getAmount()) %> MRU</td>
                <td class="py-2 px-4">
                    <span class="<%= statusClass %> text-white px-2 py-1 rounded text-xs font-semibold">
                        <%= statusText %>
                    </span>
                </td>
            </tr>
    <% } } else { %>
        <tr>
            <td colspan="4" class="text-center py-4 text-gray-500">
                Aucune transaction disponible pour cette date.
            </td>
        </tr>
    <% } %>
</tbody>

            </table>
        </div>
    </div>
</body>
</html>
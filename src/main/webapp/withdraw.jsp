<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retrait d'argent</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
            <a href="transactions.jsp" class="relative flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-exchange-alt mr-3"></i> Transactions
                <span id="notification-badge" class="absolute top-1 right-1 bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full hidden">NEW</span>
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
   <div class="flex flex-col items-center p-6 min-h-screen">
        <h2 class="text-2xl font-bold mb-6">Retrait d'argent</h2>
        <form id="withdrawForm" action="WithdrawServlet" method="post" class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
            <div class="mb-4">
                <label for="amount" class="block text-gray-700 font-semibold mb-2">Montant à retirer :</label>
                <input type="number" id="amount" name="amount" step="0.01" required
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <div id="feeInfo" class="p-4 mb-4 bg-yellow-100 border border-yellow-500 text-yellow-700 rounded-lg hidden"></div>

            <div id="passwordSection" class="mb-4 hidden">
                <label for="password" class="block text-gray-700 font-semibold mb-2">Mot de passe :</label>
                <input type="password" id="password" name="password" required
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <button type="button" id="calculateFeeBtn"
                class="w-full bg-blue-500 text-white py-2 rounded-lg font-semibold hover:bg-blue-600 transition">
                Suivent
            </button>

            <button type="submit" id="confirmWithdrawBtn" class="hidden w-full bg-green-500 text-white py-2 rounded-lg font-semibold hover:bg-green-600 transition">
                Confirmer le retrait
            </button>
        </form>

        <script>
            document.getElementById('calculateFeeBtn').addEventListener('click', () => {
                const amount = parseFloat(document.getElementById('amount').value);
                if (isNaN(amount) || amount <= 0) {
                    alert('Veuillez saisir un montant valide.');
                    return;
                }

                const fee = amount * 0.02; // Calculer les frais (2%)
                console.log('Frais calculés :', fee); // Débogage
                
                const feeInfo = document.getElementById('feeInfo');
                feeInfo.textContent = 'Frais de retrait estimés : ' + fee.toFixed(2) + ' MRU.';
                document.getElementById('feeInfo').classList.remove('hidden');
                
                document.getElementById('passwordSection').classList.remove('hidden');
                document.getElementById('confirmWithdrawBtn').classList.remove('hidden');
                document.getElementById('calculateFeeBtn').classList.add('hidden');
            });
        </script>

        <% String error = request.getParameter("error");
           if (error != null) { %>
            <div class="mt-4 p-4 bg-red-100 border border-red-500 text-red-700 rounded-lg">
                <% if ("invalid_password".equals(error)) { %>
                    Mot de passe incorrect !
                <% } else if ("invalid_amount".equals(error)) { %>
                    Montant invalide !
                <% } else if ("invalid_or_insufficient_balance".equals(error)) { %>
                    Solde insuffisant ou montant invalide !
                <% } else if ("insufficient_balance_for_fee".equals(error)) { %>
                    Solde insuffisant pour couvrir les frais de retrait. Frais estimés : <%= request.getParameter("fee") %> MRU.
                <% } else if ("admin_not_found".equals(error)) { %>
                    Erreur : Compte administrateur introuvable !
                <% } else if ("transaction_failed".equals(error)) { %>
                    Échec de la transaction ! Veuillez réessayer.
                <% } else if ("database_error".equals(error)) { %>
                    Erreur de base de données. Contactez l'administrateur.
                <% } else { %>
                    Erreur inconnue !
                <% } %>
            </div>
        <% } %>

        <% if ("withdrawal_to_admin".equals(request.getParameter("success"))) { %>
            <div class="mt-4 p-4 bg-green-100 border border-green-500 text-green-700 rounded-lg">
                Retrait réussi ! Les frais de retrait étaient de : <%= request.getParameter("fee") %> MRU.
            </div>
        <% } %>

    </div>

</body>
</html>

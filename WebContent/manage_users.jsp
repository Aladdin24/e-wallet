<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wallet.model.User" %>
<%@ page import="com.wallet.dao.UserDao" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="com.wallet.controller.VerifyPasswordServlet" %>
<%
    // Si la session existe déjà, inutile de la redéclarer
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }

    User user1 = (User) session.getAttribute("user");
    if (!"admin".equals(user1.getUsername())) {
        response.sendRedirect("dashboard.jsp?error=access_denied");
        return;
    }
%>

<%
    UserDao userDao = new UserDao();
    List<User> users = null;

    // Récupérer le paramètre de recherche par e-mail
    String searchEmail = request.getParameter("searchEmail");

    try {
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            users = userDao.searchUsersByEmail(searchEmail.trim());
        } else {
            users = userDao.getAllUsers();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>




<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Utilisateurs</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
            <a href="admin_transactions.jsp" class="flex items-center px-4 py-3 hover:bg-blue-600 rounded transition duration-300">
                <i class="fas fa-exchange-alt mr-3"></i> Transactions
            </a>
           <a href="LogoutServlet" class="flex items-center px-4 py-3 hover:bg-red-600 rounded transition duration-300">
                <i class="fas fa-sign-out-alt mr-3"></i> Déconnexion
            </a>
        </nav>
    </div>
    
    
   <!-- Contenu principal -->
    <div class="ml-64 p-8">
    
    <% if (request.getParameter("error") != null) { %>
    <div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">
        Erreur : 
        <% if ("missing_data".equals(request.getParameter("error"))) { %>
            Données manquantes. Veuillez saisir un mot de passe.
        <% } else if ("invalid_password".equals(request.getParameter("error"))) { %>
            Mot de passe incorrect.
        <% } else if ("delete_failed".equals(request.getParameter("error"))) { %>
            Échec de la suppression de l'utilisateur.
        <% } else if ("server_error".equals(request.getParameter("error"))) { %>
            Erreur serveur. Veuillez réessayer.
        <% } %>
    </div>
<% } %>
    
    
        <h2 class="text-3xl font-bold text-blue-900 mb-6">Gestion des Utilisateurs</h2>

        <!-- Barre de recherche -->
        <div class="mb-6 flex items-center space-x-4">
            <form action="manage_users.jsp" method="get" class="flex items-center bg-white p-2 rounded shadow-md w-full max-w-lg">
                <input 
                    type="text" 
                    name="searchEmail" 
                    placeholder="Rechercher par nom d'utilisation..." 
                    class="flex-grow p-2 border-none focus:outline-none"
                    value="<%= request.getParameter("searchEmail") != null ? request.getParameter("searchEmail") : "" %>"
                >
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 flex items-center">
                    <i class="fas fa-search mr-2"></i> Rechercher
                </button>
            </form>
        </div>

        <!-- Carte des utilisateurs -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% if (users != null && !users.isEmpty()) {
                for (User user : users) {
                    if (!"admin".equals(user.getUsername())) { %>
                    <div class="bg-white p-6 rounded-lg shadow-lg flex flex-col justify-between">
                        <div>
                            <h3 class="text-xl font-semibold text-gray-800 mb-2"><%= user.getUsername() %></h3>
                            <p class="text-gray-500 mb-4">Solde : <span class="text-blue-700 font-bold"><%= String.format("%.2f", user.getBalance()) %> MRU</span></p>
                        </div>
                        <div class="flex space-x-2 mt-4">
                            <button 
                                class="bg-yellow-500 text-white px-4 py-2 rounded-md hover:bg-yellow-600 transition"
                                onclick="openEditModal(<%= user.getId() %>, '<%= user.getUsername() %>', <%= user.getBalance() %>)"
                            >
                                Modifier
                            </button>
<button 
    onclick="openDeleteModal(<%= user.getId() %>)"
    class="bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600 transition">
    Supprimer
</button>

                            <button 
                                class="bg-green-500 text-white px-4 py-2 rounded-md hover:bg-green-600 transition"
                                onclick="openDepositModal(<%= user.getId() %>, '<%= user.getUsername() %>')"
                            >
                                Dépôt
                            </button>
                        </div>
                    </div>
            <% } } } else { %>
                <p class="text-gray-500 col-span-3 text-center">
                    Aucun utilisateur trouvé pour "<span class="font-semibold"><%= searchEmail %></span>"
                </p>
            <% } %>
        </div>
    </div>
    
    <!-- Modal de modification de l'utilisateur -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded-lg shadow-lg w-96">
        <h2 class="text-xl font-bold mb-4">Modifier l'utilisateur</h2>
        
        <form action="UpdateUserServlet" method="post">
            <input type="hidden" id="editUserId" name="userId">

            <div class="mb-4">
                <label for="editUsername" class="block text-gray-700">Nom d'utilisateur :</label>
                <input 
                    type="text" 
                    id="editUsername" 
                    name="username" 
                    class="w-full p-2 border border-gray-300 rounded"
                    required
                >
            </div>

            <div class="mb-4">
                <label for="editBalance" class="block text-gray-700">Solde :</label>
                <input 
                    type="number" 
                    id="editBalance" 
                    name="balance" 
                    step="0.01" 
                    min="0" 
                    class="w-full p-2 border border-gray-300 rounded"
                    required
                >
            </div>

            <div class="flex justify-end space-x-2">
                <button type="button" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600" onclick="closeEditModal()">
                    Annuler
                </button>
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                    Enregistrer
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal pour effectuer un dépôt -->
<div id="depositModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded-lg shadow-lg w-96">
        <h2 class="text-xl font-bold mb-4">Effectuer un Dépôt</h2>
        
        <form id="depositForm" action="DepositServlet" method="post">
            <input type="hidden" id="depositUserId" name="userId">
            
            <div class="mb-4">
                <label class="block text-gray-700 mb-2">Utilisateur :</label>
                <p id="depositUsername" class="text-lg font-semibold text-blue-900"></p>
            </div>

            <div class="mb-4">
                <label for="depositAmount" class="block text-gray-700">Montant à déposer :</label>
                <input 
                    type="number" 
                    id="depositAmount" 
                    name="amount" 
                    step="0.01" 
                    min="1" 
                    class="w-full p-2 border border-gray-300 rounded" 
                    placeholder="Entrez le montant en MRU" 
                    required
                >
            </div>

            <!-- Champ de confirmation du mot de passe -->
            <div class="mb-4">
                <label for="depositPassword" class="block text-gray-700">Mot de passe :</label>
                <input 
                    type="password" 
                    id="depositPassword" 
                    name="password" 
                    class="w-full p-2 border border-gray-300 rounded" 
                    placeholder="Saisissez votre mot de passe" 
                    required
                >
            </div>

            <!-- Message d'erreur si le mot de passe est incorrect -->
            <div id="passwordError" class="text-red-500 text-sm hidden mb-2">
                Mot de passe incorrect, veuillez réessayer.
            </div>

            <div class="flex justify-end space-x-2">
                <button type="button" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600" onclick="closeDepositModal()">
                    Annuler
                </button>
                <button type="button" onclick="confirmDeposit()" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                    Dépôt
                </button>
            </div>
        </form>
    </div>
</div>


<!-- Modal de confirmation -->
<div id="deleteModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded-lg shadow-lg w-96">
        <h2 class="text-xl font-bold mb-4">Confirmer la suppression</h2>
        <p class="mb-4">Veuillez saisir votre mot de passe pour confirmer la suppression :</p>

        <form id="deleteUserForm" action="DeleteUserServlet" method="post" onsubmit="return validateDeleteForm()">
            <!-- Champ caché pour l'ID utilisateur -->
            <input type="hidden" id="deleteUserId" name="userId">

            <!-- Champ de mot de passe -->
            <input 
                type="password" 
                id="deletePassword" 
                name="password" 
                placeholder="Mot de passe administrateur" 
                required
                class="w-full p-2 border border-gray-300 rounded mb-4"
            >

            <!-- Boutons d'action -->
            <div class="flex justify-end space-x-2">
                <button 
                    type="button" 
                    class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
                    onclick="closeDeleteModal()"
                >
                    Annuler
                </button>
                <button 
                    type="submit" 
                    class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
                >
                    Confirmer
                </button>
            </div>
        </form>
    </div>
</div>





<script>
    function confirmDeposit() {
        const password = document.getElementById("depositPassword").value;
        const userId = document.getElementById("depositUserId").value;

        // Vérification du mot de passe via AJAX
        fetch('VerifyPasswordServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: "userId=" + encodeURIComponent(userId) + "&password=" + encodeURIComponent(password)
        })
        .then(response => response.json())
        .then(data => {
            if (data.valid) {
                document.getElementById("depositForm").submit(); // Soumettre le formulaire si validé
            } else {
                document.getElementById("passwordError").classList.remove("hidden"); // Afficher l'erreur
            }
        })
        .catch(error => console.error('Erreur lors de la vérification du mot de passe:', error));
    }

    // Fonction pour ouvrir le modal et pré-remplir les informations
    function openDepositModal(userId, username) {
        document.getElementById('depositUserId').value = userId;
        document.getElementById('depositUsername').textContent = username;
        document.getElementById('depositModal').classList.remove('hidden');
        document.getElementById('passwordError').classList.add('hidden'); // Cacher l'erreur précédente
    }

    // Fonction pour fermer le modal
    function closeDepositModal() {
        document.getElementById('depositModal').classList.add('hidden');
    }
</script>



<script>
    // Ouvrir le modal de modification
    function openEditModal(userId, username, balance) {
        document.getElementById('editUserId').value = userId;
        document.getElementById('editUsername').value = username;
        document.getElementById('editBalance').value = balance;
        
        document.getElementById('editModal').classList.remove('hidden');
    }

    // Fermer le modal de modification
    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
    }
</script>


<script>
//Ouvrir le modal avec l'ID utilisateur
function openDeleteModal(userId) {
    document.getElementById('deleteUserId').value = userId;
    document.getElementById('deleteModal').classList.remove('hidden');
}

// Fermer le modal
function closeDeleteModal() {
    document.getElementById('deleteModal').classList.add('hidden');
}

// Validation du formulaire avant soumission
function validateDeleteForm() {
    const userId = document.getElementById('deleteUserId').value;
    const password = document.getElementById('deletePassword').value;

    if (!userId || !password) {
        alert("Veuillez saisir votre mot de passe pour confirmer la suppression.");
        return false;
    }
    return true;
}

</script>

    

</body>
</html>

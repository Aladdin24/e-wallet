<div class="bg-white p-6 rounded-lg shadow-md mb-8">
    <h4 class="text-lg font-bold text-blue-900 mb-4">Validation des Retraits</h4>
    <form action="AgentValidationServlet" method="post">
        <div class="mb-4">
            <label for="withdrawalCode" class="block text-gray-700">Code de Retrait :</label>
            <input type="text" id="withdrawalCode" name="withdrawalCode" class="w-full p-2 border border-gray-300 rounded" required>
        </div>
        <button type="submit" class="bg-green-500 text-white py-2 px-4 rounded hover:bg-green-600">
            Valider le Retrait
        </button>
    </form>
</div>

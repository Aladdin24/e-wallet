package com.wallet.service;


import com.wallet.dao.TransactionDao;
import com.wallet.model.Transaction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TransactionService {

    // Méthode pour récupérer toutes les transactions d'un utilisateur
    public List<Transaction> getUserTransactions(int userId) throws SQLException {
        Connection connection = null;
        try {
            // Chargement du pilote JDBC MySQL
            Class.forName("com.mysql.jdbc.Driver");
            // Établissement de la connexion à la base de données
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "");

            // Création d'une instance de TransactionDao
            TransactionDao transactionDao = new TransactionDao(connection);

            // Récupération des transactions
            return transactionDao.getUserTransactions(userId);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Pilote JDBC MySQL non trouvé.", e);
        } finally {
            // Fermeture de la connexion
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Méthode pour récupérer les transactions par date
    public List<Transaction> getUserTransactionsByDate(int userId, String date) throws SQLException {
        Connection connection = null;
        try {
            // Chargement du pilote JDBC MySQL
            Class.forName("com.mysql.jdbc.Driver");
            // Établissement de la connexion à la base de données
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "");

            // Création d'une instance de TransactionDao
            TransactionDao transactionDao = new TransactionDao(connection);

            // Récupération des transactions par date
            return transactionDao.getUserTransactionsByDate(userId, date);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Pilote JDBC MySQL non trouvé.", e);
        } finally {
            // Fermeture de la connexion
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
   
    
    public static class DatabaseConnection {
        private static final String DB_URL = "jdbc:mysql://localhost:3306/e_wallet"; // URL de la base de données
        private static final String DB_USER = "root"; // Nom d'utilisateur
        private static final String DB_PASSWORD = ""; // Mot de passe

        public static Connection getConnection() throws SQLException {
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        }
    }

    public double getMonthlyExpenses(int userId) {
        String query = "SELECT SUM(amount) FROM transactions WHERE sender_id = ? AND MONTH(transaction_date) = MONTH(CURRENT_DATE)";
        try (Connection connection = DatabaseConnection.getConnection(); // Récupérer la connexion
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, userId); // Définir le paramètre userId
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1); // Retourner la somme des dépenses
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0; // Retourner 0 si aucune dépense n'est trouvée
    }
    
    public double getMonthlyIncome(int userId) {
        String query = "SELECT SUM(amount) FROM transactions WHERE receiver_id = ? AND MONTH(transaction_date) = MONTH(CURRENT_DATE)";
        try (Connection connection = DatabaseConnection.getConnection(); // Récupérer la connexion
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, userId); // Définir le paramètre userId
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1); // Retourner la somme des revenus
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0; // Retourner 0 si aucun revenu n'est trouvé
    }
    public Map<String, Double> getMonthlyTransactions(int userId) {
        Map<String, Double> monthlyTransactions = new LinkedHashMap<>();
        String query = "SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month, SUM(amount) AS total " +
                       "FROM transactions WHERE sender_id = ? OR receiver_id = ? " +
                       "GROUP BY month ORDER BY month ASC";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String month = rs.getString("month");
                double total = rs.getDouble("total");
                monthlyTransactions.put(month, total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthlyTransactions;
    }
    
    
    public int getUnreadTransactionsCount(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM transactions WHERE receiver_id = ? AND is_read = 0";
        try (Connection connection = DatabaseConnection.getConnection();
        		PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

}
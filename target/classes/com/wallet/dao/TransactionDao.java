package com.wallet.dao;

import com.wallet.model.Transaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDao {
    private Connection connection;

    // Constructeur pour initialiser la connexion à la base de données
    public TransactionDao(Connection connection) {
        this.connection = connection;
    }

    // Méthode pour ajouter une nouvelle transaction
    public boolean addTransaction(Transaction transaction) throws SQLException {
        String query = "INSERT INTO transactions (sender_id, receiver_id, amount, transaction_date) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, transaction.getSenderId());
            stmt.setInt(2, transaction.getReceiverId());
            stmt.setDouble(3, transaction.getAmount());
            stmt.setTimestamp(4, transaction.getTransactionDate());

            int rowsAffected = stmt.executeUpdate();

            // Récupérer l'ID généré pour la transaction
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        transaction.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    // Méthode pour récupérer l'historique des transactions d'un utilisateur
    public List<Transaction> getUserTransactions(int userId) throws SQLException {
        List<Transaction> transactions = new ArrayList<>();
        String query = "SELECT t.id, t.sender_id, u1.username AS sender_username, " +
                "t.receiver_id, u2.username AS receiver_username, t.amount, t.transaction_date " +
                "FROM transactions t " +
                "JOIN users u1 ON t.sender_id = u1.id " +
                "JOIN users u2 ON t.receiver_id = u2.id " +
                "WHERE t.sender_id = ? OR t.receiver_id = ? " +
                "ORDER BY t.transaction_date desc LIMIT 10";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Transaction transaction = new Transaction();
                    transaction.setId(rs.getInt("id"));
                    transaction.setSenderId(rs.getInt("sender_id"));
                    transaction.setSenderUsername(rs.getString("sender_username"));
                    transaction.setReceiverId(rs.getInt("receiver_id"));
                    transaction.setReceiverUsername(rs.getString("receiver_username"));
                    transaction.setAmount(rs.getDouble("amount"));
                    transaction.setTransactionDate(rs.getTimestamp("transaction_date"));

                    transactions.add(transaction);
                }
            }
         // Log pour déboguer
            System.out.println("Nombre de transactions récupérées : " + transactions.size());
        }
        return transactions;
    }
    public List<Transaction> getUserTransactionsByDate(int userId, String date) throws SQLException {
        List<Transaction> transactions = new ArrayList<>();
        String query = """
                SELECT t.id, t.sender_id, t.receiver_id, t.amount, t.transaction_date,
                       s.username AS sender_username, r.username AS receiver_username
                FROM transactions t
                JOIN users s ON t.sender_id = s.id
                JOIN users r ON t.receiver_id = r.id
                WHERE (t.sender_id = ? OR t.receiver_id = ?) AND DATE(t.transaction_date) = ? ORDER BY t.transaction_date desc
                """;
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, userId);
            preparedStatement.setString(3, date); // Format : YYYY-MM-DD
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(resultSet.getInt("id"));
                transaction.setSenderId(resultSet.getInt("sender_id"));
                transaction.setSenderUsername(resultSet.getString("sender_username")); // Récupération du nom de l'expéditeur
                transaction.setReceiverId(resultSet.getInt("receiver_id"));
                transaction.setReceiverUsername(resultSet.getString("receiver_username")); // Récupération du nom du destinataire
                transaction.setAmount(resultSet.getDouble("amount"));
                transaction.setTransactionDate(resultSet.getTimestamp("transaction_date"));
                transactions.add(transaction);
            }
        }
        return transactions;
    }
    
    public Transaction getTransactionByWithdrawalCode(String withdrawalCode) throws SQLException {
        String query = "SELECT * FROM transactions WHERE withdrawal_code = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, withdrawalCode);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setId(rs.getInt("id"));
                transaction.setSenderId(rs.getInt("sender_id"));
                transaction.setSenderUsername(rs.getString("sender_username"));
                transaction.setReceiverId(rs.getInt("receiver_id"));
                transaction.setReceiverUsername(rs.getString("receiver_username"));
                transaction.setAmount(rs.getDouble("amount"));
                transaction.setTransactionDate(rs.getTimestamp("transaction_date"));
                
                return transaction;
            }
        }
        return null; // Retourne null si aucun code de retrait ne correspond
    }
    
    public boolean updateTransaction(Transaction transaction) throws SQLException {
        String query = "UPDATE transactions SET withdrawal_code = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
           
            stmt.setInt(2, transaction.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public void markTransactionsAsSeen(int userId) throws SQLException {
        String query = "UPDATE transactions SET is_read = 1 WHERE receiver_id = ? AND is_read = 0";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }
    
    public List<Transaction> getAllTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String query = "SELECT t.id, u1.username AS sender_username, u2.username AS receiver_username, " +
                       "t.amount, t.transaction_date " +
                       "FROM transactions t " +
                       "LEFT JOIN users u1 ON t.sender_id = u1.id " +
                       "LEFT JOIN users u2 ON t.receiver_id = u2.id " +
                       "ORDER BY t.transaction_date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setId(rs.getInt("id"));
                transaction.setSenderUsername(rs.getString("sender_username"));
                transaction.setReceiverUsername(rs.getString("receiver_username"));
                transaction.setAmount(rs.getDouble("amount"));
                transaction.setTransactionDate(rs.getTimestamp("transaction_date"));
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

 // Méthode pour obtenir le nombre de transactions récentes (ex: dernières 24 heures)
    public int getRecentTransactionCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM transactions WHERE transaction_date >= NOW() - INTERVAL 1 DAY";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }


    public boolean addTransaction1(Transaction transaction) throws SQLException {
        String query = "INSERT INTO transactions (sender_id, sender_username, receiver_id, receiver_username, amount, transaction_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, transaction.getSenderId());
            stmt.setString(2, transaction.getSenderUsername());
            stmt.setInt(3, transaction.getReceiverId());
            stmt.setString(4, transaction.getReceiverUsername());
            stmt.setDouble(5, transaction.getAmount());
            stmt.setTimestamp(6, transaction.getTransactionDate());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public int getNewTransactionCountForAdmin() throws SQLException {
        String query = "SELECT COUNT(*) FROM transactions WHERE seen_by_admin = 0";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public void markTransactionsAsSeenByAdmin() throws SQLException {
        String query = "UPDATE transactions SET seen_by_admin = 1 WHERE seen_by_admin = 0";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.executeUpdate();
        }
    }

    public List<Transaction> getTransactionsBySenderUsername(String senderUsername) {
        List<Transaction> transactions = new ArrayList<>();
        
        String sql = "SELECT t.*, u.username AS sender_username, ur.username AS receiver_username " +
                     "FROM transactions t " +
                     "JOIN users u ON t.sender_id = u.id " +
                     "JOIN users ur ON t.receiver_id = ur.id " +
                     "WHERE u.username LIKE ? " +
                     "ORDER BY t.transaction_date DESC";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, "%" + senderUsername + "%");
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Transaction transaction = new Transaction();
                transaction.setId(resultSet.getInt("id"));
                transaction.setSenderId(resultSet.getInt("sender_id"));
                transaction.setSenderUsername(resultSet.getString("sender_username"));
                transaction.setReceiverId(resultSet.getInt("receiver_id"));
                transaction.setReceiverUsername(resultSet.getString("receiver_username"));
                transaction.setAmount(resultSet.getDouble("amount"));
                transaction.setTransactionDate(resultSet.getTimestamp("transaction_date"));
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }




    
}
// UserDao.java
package com.wallet.dao;

import com.wallet.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    private Connection connection;

    public UserDao(Connection connection) {
        this.connection = connection;
    }
    
    public UserDao() {
        try {
            this.connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_wallet", "root", "");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try {
            String query = "SELECT * FROM users";
            PreparedStatement stmt = connection.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setBalance(rs.getDouble("balance"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Méthode pour vérifier si un utilisateur existe par nom d'utilisateur ou email
    public User getUserByUsernameOrEmail(String username, String email) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ? OR email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setBalance(rs.getDouble("balance"));
                return user;
            }
        }
        return null;
    }

    // Méthode pour enregistrer un nouvel utilisateur
    public boolean registerUser(User user) throws SQLException {
        String query = "INSERT INTO users (username, password, email, balance) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword()); // Note : Hachez le mot de passe avant de l'insérer
            stmt.setString(3, user.getEmail());
            stmt.setDouble(4, user.getBalance());
            return stmt.executeUpdate() > 0;
        }
    }


    public User loginUser(String username, String password) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setBalance(rs.getDouble("balance"));
                return user;
            }
        }
        return null;
    }
 // UserDao.java
    public boolean updateUserBalance(int userId, double newBalance) throws SQLException {
        String query = "UPDATE users SET balance = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDouble(1, newBalance);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    
    // Méthode pour récupérer un utilisateur par son ID
    public User getUserById(int userId) throws SQLException {
        String query = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setBalance(rs.getDouble("balance"));
                    return user;
                }
            }
        }
        return null;
    }
    
 // Méthode pour récupérer un utilisateur par son nom d'utilisateur
    public User getUserByUsername(String username) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setBalance(rs.getDouble("balance"));
                return user;
            }
        }
        return null; // Retourne null si aucun utilisateur n'est trouvé
    }
    public boolean validateUserPassword(String username, String password) {
        String query = "SELECT password FROM users WHERE username = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, username);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String storedPassword = resultSet.getString("password");
                return storedPassword.equals(password); // Compare les mots de passe
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Retourne false si l'utilisateur n'existe pas ou en cas d'erreur
    }
    
    public boolean deleteUserById(int userId) {
        try {
        	 // Supprimer d'abord les transactions liées à l'utilisateur
            String deleteTransactionsQuery = "DELETE FROM transactions WHERE sender_id = ? OR receiver_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(deleteTransactionsQuery)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, userId);
                stmt.executeUpdate();
            }


            // Ensuite, supprimer l'utilisateur
            String deleteUserQuery = "DELETE FROM users WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(deleteUserQuery)) {
                stmt.setInt(1, userId);
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
 // Méthode pour récupérer le nombre total d'utilisateurs
    public int getUserCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM users";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Méthode pour obtenir le solde total de tous les utilisateurs
    public double getTotalBalance() throws SQLException {
        String query = "SELECT SUM(balance) FROM users";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public boolean updateUser(User user) throws SQLException {
        String query = "UPDATE users SET username = ?, balance = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, user.getUsername());
            stmt.setDouble(2, user.getBalance());
            stmt.setInt(3, user.getId());
            return stmt.executeUpdate() > 0;
        }
    }
    
 // Méthode pour rechercher des utilisateurs par e-mail (nom d'utilisateur)
    public List<User> searchUsersByEmail(String email) throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE username LIKE ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, "%" + email + "%"); // Recherche partielle avec LIKE
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setBalance(rs.getDouble("balance"));
                    users.add(user);
                }
            }
        }
        return users;
    }
    
    public boolean verifyPassword(String username, String password) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ? AND password = ?";
        ResultSet resultSet = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password); 
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (resultSet != null) {
                try { resultSet.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



}
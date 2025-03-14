package com.wallet.model;

import java.sql.Timestamp;

public class Transaction {
    // Attributs de la transaction
    private int id;
    private int transactionId;
    private int senderId; // ID de l'expéditeur
    private String senderUsername; // Nom d'utilisateur de l'expéditeur (pour affichage)
    private int receiverId; // ID du destinataire
    private String receiverUsername; // Nom d'utilisateur du destinataire (pour affichage)
    private double amount; // Montant de la transaction
    private Timestamp transactionDate; // Date et heure de la transaction


    // Constructeur par défaut
    public Transaction() {
    }

    // Constructeur avec paramètres
    public Transaction(int id, int senderId, String senderUsername, int receiverId, String receiverUsername, double amount, Timestamp transactionDate) {
        this.id = id;
        this.senderId = senderId;
        this.senderUsername = senderUsername;
        this.receiverId = receiverId;
        this.receiverUsername = receiverUsername;
        this.amount = amount;
        this.transactionDate = transactionDate;
    }
    
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    // Getters et Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public String getSenderUsername() {
        return senderUsername;
    }

    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public String getReceiverUsername() {
        return receiverUsername;
    }

    public void setReceiverUsername(String receiverUsername) {
        this.receiverUsername = receiverUsername;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Timestamp getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }
    
   

  

    // Méthode toString pour afficher les informations de la transaction (optionnel)
    @Override
    public String toString() {
        return "Transaction{" +
                "id=" + id +
                ", senderId=" + senderId +
                ", senderUsername='" + senderUsername + '\'' +
                ", receiverId=" + receiverId +
                ", receiverUsername='" + receiverUsername + '\'' +
                ", amount=" + amount +
                ", transactionDate=" + transactionDate +
                '}';
    }
}
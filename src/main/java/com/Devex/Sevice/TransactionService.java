package com.Devex.Sevice;

import com.Devex.Entity.OrderDetails;

public interface TransactionService {

    public void transactionBackToUser(OrderDetails orderDetails);
    public void transactionBackToSeller(OrderDetails orderDetails);
    public void transactionDwallet(String from, String to, double value, String payment);
}
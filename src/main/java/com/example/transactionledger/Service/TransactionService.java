package com.example.transactionledger.Service;

import java.util.Date;
import java.util.UUID;

public interface TransactionService {

    String getCurrentBalance(UUID accountId);

    String getBalance(UUID accountId, Date fromDate, Date toDate);
}

package com.example.transactionledger.Service;

import com.example.transactionledger.model.ProjectedTransactionTotal;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface RegressionService {
    List<ProjectedTransactionTotal> performLinearRegression(UUID accountId, Date fromDate, Date toDate);
}

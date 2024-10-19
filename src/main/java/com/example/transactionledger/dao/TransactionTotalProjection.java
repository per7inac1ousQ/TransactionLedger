package com.example.transactionledger.dao;

import java.math.BigDecimal;

public interface TransactionTotalProjection {
    Integer getYear();
    Integer getMonth();
    BigDecimal getTotalDebits();
    BigDecimal getTotalCredits();
    BigDecimal getClosingBalance();
    void setYear(Integer year);
    void setMonth(Integer month);
    void setTotal_debits(BigDecimal totalDebits);
    void setTotal_credits(BigDecimal totalCredits);
    void setClosing_balance(BigDecimal closingBalance);
}
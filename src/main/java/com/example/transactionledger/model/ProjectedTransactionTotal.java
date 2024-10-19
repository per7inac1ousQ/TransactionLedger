package com.example.transactionledger.model;

import com.example.transactionledger.dao.TransactionTotalProjection;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Date;
import java.util.UUID;

@AllArgsConstructor
public class ProjectedTransactionTotal implements TransactionTotalProjection {

    Integer year;
    Integer month;
    BigDecimal total_debits;
    BigDecimal total_credits;
    BigDecimal closing_balance;

    @Override
    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public BigDecimal getTotal_debits() {
        return total_debits;
    }

    public BigDecimal getTotal_credits() {
        return total_credits;
    }

    public BigDecimal getClosing_balance() {
        return closing_balance;
    }

    public void setMonth(Integer month) {
        this.month = month;
    }

    public void setTotal_debits(BigDecimal total_debits) {
        this.total_debits = total_debits;
    }

    public void setTotal_credits(BigDecimal total_credits) {
        this.total_credits = total_credits;
    }

    public void setClosing_balance(BigDecimal closing_balance) {
        this.closing_balance = closing_balance;
    }

    @Override
    public Integer getMonth() {
        return month;
    }

    @Override
    public BigDecimal getTotalDebits() {
        return total_debits;
    }

    @Override
    public BigDecimal getTotalCredits() {
        return total_credits;
    }

    @Override
    public BigDecimal getClosingBalance() {
        return closing_balance;
    }
}

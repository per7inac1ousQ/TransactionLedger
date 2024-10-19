package com.example.transactionledger.dao;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
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

@Data
@Builder
@NoArgsConstructor
@Entity
@AllArgsConstructor
@Table(name = "transactions")
public class TransactionTotal {

    @Id
    @Column(name = "transaction_id")
    private UUID id;

    @NotNull
    @Column(name = "transaction_date")
    private Date transactionDate;

    @NotNull
    @Column(name = "from_account_id")
    private UUID fromAccountId;

    @NotNull
    @Column(name = "to_account_id")
    private UUID toAccountId;

    @NotNull
    private BigDecimal amount;

}

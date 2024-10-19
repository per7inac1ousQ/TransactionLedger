package com.example.transactionledger.Repository;

import com.example.transactionledger.dao.TransactionTotal;
import com.example.transactionledger.dao.TransactionTotalProjection;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Repository
public interface TransactionRepository extends CrudRepository<TransactionTotal, UUID> {

    @Query(value = """
                    SELECT EXTRACT(YEAR FROM tt.transactionDate) AS year,\
                        EXTRACT(MONTH FROM tt.transactionDate) AS month,\
                       SUM(CASE WHEN tt.fromAccountId=:accountId THEN tt.amount ELSE 0 END) AS totalDebits,\
                       SUM(CASE WHEN tt.toAccountId=:accountId THEN tt.amount ELSE 0 END) AS totalCredits,\
                       SUM(CASE WHEN tt.fromAccountId=:accountId THEN tt.amount ELSE 0 END) -
                       SUM(CASE WHEN tt.toAccountId=:accountId THEN tt.amount ELSE 0 END) AS closingBalance \
                    FROM TransactionTotal tt \
                    WHERE tt.transactionDate BETWEEN :fromDate AND :toDate \
                    GROUP by month, year
                    ORDER BY EXTRACT(YEAR FROM tt.transactionDate)
                    """)
    List<TransactionTotalProjection> fetchTransactionTotalsForSpecificMonths(@Param("accountId") UUID accountId,
                                                                             @Param("fromDate") Date fromDate,
                                                                             @Param("toDate") Date toDate);


    @Query(value = """
            select
                EXTRACT(YEAR FROM tt.transactionDate) AS year,\
                EXTRACT(MONTH FROM tt.transactionDate) AS month,\
                SUM(CASE WHEN tt.fromAccountId=:accountId THEN tt.amount ELSE 0 END) AS totalDebits,\
                SUM(CASE WHEN tt.toAccountId=:accountId THEN tt.amount ELSE 0 END) AS totalCredits
            FROM TransactionTotal tt \
            GROUP BY month, year
            ORDER BY EXTRACT(YEAR FROM tt.transactionDate)
            LIMIT 12
            """)
    List<TransactionTotalProjection> fetchTransactionTotalsForPastTwelveMonths(@Param("accountId") UUID accountId);


}

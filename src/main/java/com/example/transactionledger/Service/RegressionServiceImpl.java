package com.example.transactionledger.Service;

import com.example.transactionledger.Repository.TransactionRepository;
import com.example.transactionledger.dao.TransactionTotalProjection;
import com.example.transactionledger.model.ProjectedTransactionTotal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.math3.stat.regression.SimpleRegression;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class RegressionServiceImpl implements RegressionService {

    @Autowired
    TransactionRepository transactionRepository;

    @Override
    public List<ProjectedTransactionTotal> performLinearRegression(UUID accountId, Date fromDate, Date toDate) {

        List<TransactionTotalProjection> transactionTotalProjections = transactionRepository.fetchTransactionTotalsForPastTwelveMonths(accountId);
        List<ProjectedTransactionTotal> projectedTransactionTotals = new ArrayList<>();

        SimpleRegression debitRegression = new SimpleRegression();
        SimpleRegression creditRegression = new SimpleRegression();

        for (TransactionTotalProjection transactionTotalProjection : transactionTotalProjections) {
            int month = transactionTotalProjection.getMonth();
            BigDecimal totalDebits = transactionTotalProjection.getTotalDebits();
            BigDecimal totalCredits = transactionTotalProjection.getTotalCredits();

            debitRegression.addData((double) month, totalDebits.doubleValue());
            creditRegression.addData((double) month, totalCredits.doubleValue());

        }

        Calendar fromCal = Calendar.getInstance();
        fromCal.setTime(fromDate);
        Calendar toCal = Calendar.getInstance();
        toCal.setTime(toDate);

        log.info("________ STARTING REGRESSION ________");
        while (!fromCal.after(toCal)) {
            int futureMonthIndex = fromCal.get(Calendar.MONTH) + 1;
            int futureYear = fromCal.get(Calendar.YEAR);

            //predictions
            double predictedDebits = debitRegression.predict(futureMonthIndex);
            double predictedCredits = creditRegression.predict(futureMonthIndex);
            double predictedClosingBalance = predictedDebits - predictedCredits;

            ProjectedTransactionTotal projectedTransactionTotal = new ProjectedTransactionTotal(futureYear,
                    futureMonthIndex,BigDecimal.valueOf(predictedDebits),BigDecimal.valueOf(predictedCredits),BigDecimal.valueOf(predictedClosingBalance));
            projectedTransactionTotal.setMonth(futureMonthIndex);
            projectedTransactionTotal.setYear(futureYear);
            projectedTransactionTotal.setTotal_debits(BigDecimal.valueOf(predictedDebits));
            projectedTransactionTotal.setTotal_credits(BigDecimal.valueOf(predictedCredits));
            projectedTransactionTotals.add(projectedTransactionTotal);

            fromCal.add(Calendar.MONTH, 1);
            printRegressionResults(futureMonthIndex, debitRegression, creditRegression,predictedDebits,predictedCredits);

        }
        log.info("________ REGRESSION FINISHED ________");


        return projectedTransactionTotals;
    }


    private void printRegressionResults(int futureMonthIndex, SimpleRegression debitRegression, SimpleRegression creditRegression, double predictedDebits, double predictedCredits) {
        log.info("Regression Results:");
        log.info("\nPredicted Debits for Month " + futureMonthIndex + ": " + predictedDebits);
        log.info("\nDebit Regression Slope: " + debitRegression.getSlope());
        log.info("Debit Regression Intercept: " + debitRegression.getIntercept());
        log.info("Debit Regression R^2: " + debitRegression.getRSquare());

        log.info("Predicted Credits for Month " + futureMonthIndex + ": " + predictedCredits);
        log.info("\nCredit Regression Slope: " + creditRegression.getSlope());
        log.info("Credit Regression Intercept: " + creditRegression.getIntercept());
        log.info("Credit Regression R^2: " + creditRegression.getRSquare());
    }
}

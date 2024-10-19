package com.example.transactionledger.Service;

import com.example.transactionledger.Repository.AccountRepository;
import com.example.transactionledger.Repository.TransactionRepository;
import com.example.transactionledger.dao.Account;
import com.example.transactionledger.dao.TransactionTotalProjection;
import com.example.transactionledger.error.LedgerErrorType;
import com.example.transactionledger.exceptions.GenericRunTimeErrorException;
import com.example.transactionledger.model.ProjectedTransactionTotal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private RegressionService regressionService;

    @Autowired
    private AccountRepository accountRepository;


    @Override
    public String getCurrentBalance(UUID accountId) {
        Optional<Account> account = accountRepository.findById(accountId);
        if (account.isPresent()) {
            return account.get().getBalance().toString();
        } else {
            return String.format("Account not found, check account id %s is correct", accountId);
        }
    }

    @Override
    public String getBalance(final UUID accountId, final Date fromDate, final Date toDate) {
        validateDates(fromDate, toDate);

        Date current = new Date();
        List<ProjectedTransactionTotal> projectedTotals = new ArrayList<>();
        List<TransactionTotalProjection> pastTotals = new ArrayList<>();

        if (fromDate.after(current) && toDate.after(current)) {
            Date nextDay = getNextDay(current);
            projectedTotals = regressionService.performLinearRegression(accountId, nextDay, toDate);
        } else if (toDate.after(current)) {
            projectedTotals = regressionService.performLinearRegression(accountId, current, toDate);
            pastTotals = transactionRepository.fetchTransactionTotalsForSpecificMonths(accountId, fromDate, current);
        } else {
            pastTotals = transactionRepository.fetchTransactionTotalsForSpecificMonths(accountId, fromDate, toDate);
        }

        final StringBuilder table = generateHtmlResultsTable(pastTotals, projectedTotals);
        return table.toString();
    }

    private Date getNextDay(final Date current) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(current);
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        return calendar.getTime();
    }

    private static StringBuilder generateHtmlResultsTable(List<TransactionTotalProjection> pastTotals, List<ProjectedTransactionTotal> projectedTotals) {
        final StringBuilder table = new StringBuilder();
        table.append("<table cellspacing=10>");
        table.append("<thead>");
        table.append("<tr>");
        table.append("<th>Year</th>");
        table.append("<th>Month</th>");
        table.append("<th>Total Debits</th>");
        table.append("<th>Total Credits</th>");
        table.append("<th>Closing Balance</th>");
        table.append("</tr>");
        table.append("</thead>");

        table.append("<tbody>");
        for (TransactionTotalProjection total: pastTotals) {
            Integer year = total.getYear();
            Integer month = total.getMonth();
            String actualMonth = calculateMonth(month);
            BigDecimal totalDebits = total.getTotalDebits();
            BigDecimal totalCredits = total.getTotalCredits();
            BigDecimal closingBalance = total.getClosingBalance();
            table.append("<tr>");
            table.append("<td>").append(year).append("</td>");
            table.append("<td>").append(actualMonth).append("</td>");
            table.append("<td>").append(totalDebits).append("</td>");
            table.append("<td>").append(totalCredits).append("</td>");
            table.append("<td>").append(closingBalance).append("</td>");
            table.append("</tr>");

        }
        if (!projectedTotals.isEmpty()) {
            for (ProjectedTransactionTotal projected: projectedTotals) {
                Integer year = projected.getYear();
                Integer month = projected.getMonth();
                String actualMonth = calculateMonth(month);
                BigDecimal totalDebits = projected.getTotalDebits();
                BigDecimal totalCredits = projected.getTotalCredits();
                BigDecimal closingBalance = projected.getClosingBalance();
                table.append("<tr>");
                table.append("<td>").append(year).append("</td>");
                table.append("<td>").append(actualMonth).append("</td>");
                table.append("<td>").append(totalDebits).append("</td>");
                table.append("<td>").append(totalCredits).append("</td>");
                table.append("<td>").append(closingBalance).append(" (projected)</td>");
                table.append("</tr>");
            }
        }
        table.append("</tbody>");
        table.append("</table>");
        return table;
    }

    private static String calculateMonth(Integer month) {
        switch (month) {
            case 1:
                return "January";
            case 2:
                return "February";
            case 3:
                return "March";
            case 4:
                return "April";
            case 5:
                return "May";
            case 6:
                return "June";
            case 7:
                return "July";
            case 8:
                return "August";
            case 9:
                return "September";
            case 10:
                return "October";
            case 11:
                return "November";
            case 12:
                return "December";
            default:
                return "";
        }
    }

    private void validateDates(final Date fromDate, final Date toDate) {
        log.info("Validating dates passed are correct");
        if (fromDate.after(toDate)) {
            throw new GenericRunTimeErrorException(LedgerErrorType.DATES_TIME_MISMATCH, fromDate, toDate);
        }

        // TODO: Add validation to not allow dates more than 3 months into the future.
    }
}

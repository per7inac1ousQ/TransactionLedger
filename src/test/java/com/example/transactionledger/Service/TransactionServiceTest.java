package com.example.transactionledger.Service;

import com.example.transactionledger.Repository.AccountRepository;
import com.example.transactionledger.Repository.TransactionRepository;
import com.example.transactionledger.config.DatabaseTestConfiguration;
import com.example.transactionledger.dao.Account;
import com.example.transactionledger.dao.TransactionTotalProjection;
import com.example.transactionledger.exceptions.GenericRunTimeErrorException;
import com.example.transactionledger.model.AccountType;
import com.example.transactionledger.model.ProjectedTransactionTotal;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.projection.ProjectionFactory;
import org.springframework.data.projection.SpelAwareProxyProjectionFactory;
import org.springframework.test.context.ActiveProfiles;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;

@SpringBootTest(classes= DatabaseTestConfiguration.class)
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class TransactionServiceTest {

    @MockBean
    @Qualifier("testDataSource")
    DataSource datasource;
    @Mock
    private TransactionRepository transactionRepository;
    @Mock
    private RegressionService regressionService;
    @Mock
    private AccountRepository accountRepository;

    @InjectMocks
    private TransactionServiceImpl transactionService;

    private  Account account = null;

    private static final UUID ACCOUNT_ID = UUID.fromString("bf443c25-ff57-4f8c-9db0-545f90926d9a");

    @BeforeEach
    void setUp() {
        account = buildAccount();
    }

    @Test
    public void test_givenAccountUUID_whenSearchingForBalance_ThenAccountBalanceIsReturned(){
        given(accountRepository.findById(any())).willReturn(Optional.ofNullable(account));
        assert account != null;

        final String balance = transactionService.getCurrentBalance(account.getAccountId());
        assertEquals(balance, account.getBalance().toString());
    }

    @Test
    public void test_givenAccountUUID_whenSearchingForBalanceAndAccountDoesNotExist_ThenReturn404(){
        given(accountRepository.findById(any())).willReturn(Optional.empty());

        final String result = transactionService.getCurrentBalance(account.getAccountId());
        assertEquals(result, "Account not found, check account id bf443c25-ff57-4f8c-9db0-545f90926d9a is correct");
    }

    @Test
    public void test_whenToDateIsBeforeFromDate_ThenThrow500(){
        Date fromDate = new Date(2024,6,7);
        Date toDate = new Date(2023, 3, 5);
        given(accountRepository.findById(any())).willReturn(Optional.empty());

        assertThrows(GenericRunTimeErrorException.class, () -> transactionService.getBalance(account.getAccountId(), fromDate, toDate));
    }

    @Test
    public void test_whenDatesAreInThePast_ThenReturnBalance(){
        Date fromDate = new Date(2022,6,7);
        Date toDate = new Date(2023, 3, 5);
        List<TransactionTotalProjection> pastTotals = generatePastTotals();
        given(transactionRepository.fetchTransactionTotalsForSpecificMonths(account.getAccountId(), fromDate, toDate)).willReturn(pastTotals);
        String result = transactionService.getBalance(account.getAccountId(), fromDate, toDate);

        assertEquals("<table cellspacing=10><thead><tr><th>Year</th><th>Month</th><th>Total Debits</th><th>Total Credits</th><th>Closing Balance</th></tr></thead><tbody></tbody></table>", result);
    }

    @Test
    public void test_whenCurrentDateOverlaps_ThenReturnPastBalanceAndPrediction(){
        Date fromDate = new Date(2020,6,7);
        Date toDate = new Date(2050, 3, 5);
        List<TransactionTotalProjection> pastTotals = generatePastTotals();
        List<ProjectedTransactionTotal> predictedTotals = generatePredictedTotals();
        given(transactionRepository.fetchTransactionTotalsForSpecificMonths(account.getAccountId(), fromDate, toDate)).willReturn(pastTotals);
        given(regressionService.performLinearRegression(any(), any(), any())).willReturn(predictedTotals);
        String result = transactionService.getBalance(account.getAccountId(), fromDate, toDate);


        assertEquals("<table cellspacing=10><thead><tr><th>Year</th><th>Month</th><th>Total Debits</th><th>Total Credits</th><th>Closing Balance</th></tr></thead><tbody><tr><td>2023</td><td>June</td><td>200</td><td>550</td><td>250 (projected)</td></tr><tr><td>2023</td><td>May</td><td>500</td><td>300</td><td>200 (projected)</td></tr></tbody></table>", result);
    }



    @Test
    public void test_whenBothDatesAreInTheFuture_ThenReturnAPrediction(){
        Date fromDate = new Date(2100,6,7);
        Date toDate = new Date(2150, 3, 5);
        List<TransactionTotalProjection> pastTotals = generatePastTotals();
        List<ProjectedTransactionTotal> predictedTotals = generatePredictedTotals();
        given(regressionService.performLinearRegression(account.getAccountId(), fromDate, toDate)).willReturn(predictedTotals);
        String result = transactionService.getBalance(account.getAccountId(), fromDate, toDate);

        assertEquals("<table cellspacing=10><thead><tr><th>Year</th><th>Month</th><th>Total Debits</th><th>Total Credits</th><th>Closing Balance</th></tr></thead><tbody></tbody></table>", result);
    }



    private List<TransactionTotalProjection> generatePastTotals() {
        List<TransactionTotalProjection> pastTotals = new ArrayList<>();
        ProjectionFactory factory = new SpelAwareProxyProjectionFactory();
        TransactionTotalProjection projection1 = factory.createProjection(TransactionTotalProjection.class);
        projection1.setYear(2023);
        projection1.setMonth(6);
        projection1.setTotal_credits(BigDecimal.valueOf(200L));
        projection1.setTotal_debits(BigDecimal.valueOf(300L));
        projection1.setClosing_balance(BigDecimal.valueOf(100L));
        pastTotals.add(projection1);
        TransactionTotalProjection projection2 = factory.createProjection(TransactionTotalProjection.class);
        projection2.setYear(2023);
        projection2.setMonth(5);
        projection2.setTotal_credits(BigDecimal.valueOf(500L));
        projection2.setTotal_debits(BigDecimal.valueOf(300L));
        projection2.setClosing_balance(BigDecimal.valueOf(200L));
        pastTotals.add(projection2);

        return pastTotals;
    }

    private List<ProjectedTransactionTotal> generatePredictedTotals() {
        List<ProjectedTransactionTotal> predictedTotals = new ArrayList<>();
        ProjectedTransactionTotal projection1 = new ProjectedTransactionTotal(2023,6,BigDecimal.valueOf(200L),BigDecimal.valueOf(550L),BigDecimal.valueOf(250L));
        predictedTotals.add(projection1);
        ProjectedTransactionTotal projection2 = new ProjectedTransactionTotal(2023,5,BigDecimal.valueOf(500L),BigDecimal.valueOf(300L),BigDecimal.valueOf(200L));
        predictedTotals.add(projection2);

        return predictedTotals;
    }

    private Account buildAccount() {
        return Account.builder()
                .accountId(ACCOUNT_ID)
                .accountType(AccountType.CURRENT)
                .balance(new BigDecimal(20.0))
                .createdAt(new Timestamp(28308L))
                .userId(UUID.randomUUID())
                .build();
    }

}

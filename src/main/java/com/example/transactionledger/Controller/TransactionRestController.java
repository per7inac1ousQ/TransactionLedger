package com.example.transactionledger.Controller;

import com.example.transactionledger.Service.TransactionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.UUID;

@Slf4j
@RestController
@RequiredArgsConstructor
public class TransactionRestController {

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/")
    public String index() {
        log.info("Index page loaded");
        return """
        Welcome to the transaction Ledger!
        """;
    }

    @GetMapping("/balance/{accountId}/current")
    public ResponseEntity<String> getBalance(@PathVariable UUID accountId) {
        log.info("Fetching current balance for account: [{}]", accountId);
        String balance = transactionService.getCurrentBalance(accountId);
        return ResponseEntity.ok().body(balance);

    }

    @GetMapping("/balance/{accountId}")
    public ResponseEntity<String> getBalance(@PathVariable UUID accountId,
                             @RequestParam(value = "fromDate") @DateTimeFormat(pattern="dd/MM/yyyy") Date fromDate,
                             @RequestParam(value = "toDate") @DateTimeFormat(pattern="dd/MM/yyyy") Date toDate
    ) {
        log.info("Fetching balance for account: [{}]", accountId);

        String balance = transactionService.getBalance(accountId, fromDate, toDate);
        return ResponseEntity.ok().body(balance);
    }



}

package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.example.transactionledger")
public class TransactionLedgerApplication {

	public static void main(String[] args) {
		SpringApplication.run(TransactionLedgerApplication.class, args);
	}

}


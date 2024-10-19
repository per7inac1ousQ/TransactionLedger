package com.example.transactionledger.Repository;

import com.example.transactionledger.dao.Account;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;


public interface AccountRepository extends CrudRepository<Account, UUID> {}

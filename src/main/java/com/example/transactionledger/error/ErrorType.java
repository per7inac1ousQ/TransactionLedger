package com.example.transactionledger.error;


import org.springframework.http.HttpStatus;

public interface ErrorType {

    /**
     * HTTP status to set for the REST response
     *
     * @return Status
     */
    HttpStatus getHttpStatus();

    /**
     * The message to print to the end user
     *
     * @return
     */
    String getMessage();

}

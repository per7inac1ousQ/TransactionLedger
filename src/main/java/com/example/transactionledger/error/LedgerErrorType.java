package com.example.transactionledger.error;

import org.springframework.http.HttpStatus;

public enum LedgerErrorType implements ErrorType {

    ACCOUNT_NOT_FOUND(
            HttpStatus.NOT_FOUND,
            "Account '%s' not found"),
    DATES_TIME_MISMATCH(
            HttpStatus.INTERNAL_SERVER_ERROR,
            "fromDate '%s' cannot be after toDate '%s'");

    private final HttpStatus httpStatus;
    private final String message;

    @Override
    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    @Override
    public String getMessage() {
        return message;
    }


    LedgerErrorType(HttpStatus httpStatus, String message) {
        this.httpStatus = httpStatus;
        this.message = message;
    }
}

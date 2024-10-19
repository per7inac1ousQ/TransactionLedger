package com.example.transactionledger.exceptions;

import com.example.transactionledger.error.ErrorType;
import lombok.Getter;

@Getter
public class GenericRunTimeErrorException extends RuntimeException {

    private ErrorType errorType;
    private Object[] args;

    public GenericRunTimeErrorException(ErrorType errorType, Object... args) {
        this.errorType = errorType;
        this.args = args;
    }

}

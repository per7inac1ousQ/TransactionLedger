package com.example.transactionledger.exceptions;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

@ControllerAdvice
public class ExceptionHandler {

    @org.springframework.web.bind.annotation.ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity handleMissingParams(MissingServletRequestParameterException ex) {
        return ResponseEntity.badRequest().body(String.format("Missing parameter with name:%s", ex.getParameterName()));
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity handleDateFormat(MethodArgumentTypeMismatchException ex) {
        return ResponseEntity.badRequest().body(String.format(ex.getMessage()));
    }
}

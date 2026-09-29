package com.MandiMinutes.MMBackend.exception;


public class ConcurrentTransactionException extends RuntimeException {
    public ConcurrentTransactionException(String message) {
        super(message);
    }
}

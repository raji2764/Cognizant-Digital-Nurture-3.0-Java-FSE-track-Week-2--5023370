CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_balance Accounts.balance%TYPE;
BEGIN
    -- Check for deposits
    IF :NEW.transaction_type = 'DEPOSIT' THEN
        IF :NEW.amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Deposit amount must be positive.');
        END IF;
    
    -- Check for withdrawals
    ELSIF :NEW.transaction_type = 'WITHDRAWAL' THEN
        -- Fetch the current balance of the account
        SELECT balance INTO v_balance
        FROM Accounts
        WHERE account_id = :NEW.account_id;
        
        -- Check if the withdrawal amount exceeds the balance
        IF :NEW.amount > v_balance THEN
            RAISE_APPLICATION_ERROR(-20002, 'Withdrawal amount exceeds the available balance.');
        END IF;
        
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Invalid transaction type. Must be DEPOSIT or WITHDRAWAL.');
    END IF;
END CheckTransactionRules;
/

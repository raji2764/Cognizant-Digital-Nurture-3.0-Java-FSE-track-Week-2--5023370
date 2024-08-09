--EXERCISE5 SCENE2
CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Insert a record into the AuditLog table
    INSERT INTO AuditLog (audit_id, transaction_id, transaction_date, amount, account_id, log_date)
    VALUES (AuditLog_seq.NEXTVAL, -- Assuming there is a sequence named AuditLog_seq for audit_id
            :NEW.transaction_id,
            :NEW.transaction_date,
            :NEW.amount,
            :NEW.account_id,
            SYSDATE);
END LogTransaction;
/

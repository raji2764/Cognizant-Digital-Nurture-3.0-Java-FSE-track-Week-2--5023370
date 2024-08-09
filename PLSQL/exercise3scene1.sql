CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest 
IS
    v_account_id accounts.account_id%TYPE;
    v_balance accounts.balance%TYPE;
    v_interest_rate CONSTANT NUMBER := 0.01; -- 1% interest rate
BEGIN
    -- Cursor to select all savings accounts
    FOR rec IN (SELECT account_id, balance FROM accounts WHERE account_type = 'SAVINGS') LOOP
        v_account_id := rec.account_id;
        v_balance := rec.balance;

        -- Calculate new balance by applying 1% interest
        v_balance := v_balance + (v_balance * v_interest_rate);

        -- Update the account balance
        UPDATE accounts
        SET balance = v_balance
        WHERE account_id = v_account_id;
    END LOOP;

    -- Commit the transaction
    COMMIT;

    -- Log success message
    DBMS_OUTPUT.PUT_LINE('Monthly interest processed successfully for all savings accounts.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle all other exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM || '. Processing failed.');
        ROLLBACK;
END ProcessMonthlyInterest;
/

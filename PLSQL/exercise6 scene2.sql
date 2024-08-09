DECLARE
    -- Define the annual maintenance fee
    v_annual_fee NUMBER := 50;

    -- Define a cursor to retrieve all accounts
    CURSOR c_accounts IS
        SELECT account_id, balance
        FROM Accounts
        FOR UPDATE;
    
    -- Define variables to hold cursor data
    v_account_id Accounts.account_id%TYPE;
    v_balance Accounts.balance%TYPE;
BEGIN
    -- Open and loop through the cursor
    FOR rec IN c_accounts LOOP
        -- Deduct the annual maintenance fee from the balance
        v_account_id := rec.account_id;
        v_balance := rec.balance - v_annual_fee;

        -- Update the balance in the Accounts table
        UPDATE Accounts
        SET balance = v_balance
        WHERE account_id = v_account_id;
        
        -- Print a confirmation message (optional)
        DBMS_OUTPUT.PUT_LINE('Applied annual fee of $' || v_annual_fee || ' to account ' || v_account_id || '. New balance: $' || v_balance);
    END LOOP;

    -- Commit the transaction
    COMMIT;

    -- Print a completion message
    DBMS_OUTPUT.PUT_LINE('Annual fee applied to all accounts successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any exceptions
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/
